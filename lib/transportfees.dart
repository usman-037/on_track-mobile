import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:ontrack/MongoDBModel.dart';

import 'dbHelper/mongodb.dart';
import 'transportfeeslip.dart';

class TransportFeeDepositScreen extends StatefulWidget {
  @override
  _TransportFeeDepositScreenState createState() =>
      _TransportFeeDepositScreenState();
}

class _TransportFeeDepositScreenState extends State<TransportFeeDepositScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController sectioncontroller = TextEditingController();
  TextEditingController routenocontroller = TextEditingController();
  TextEditingController feeAmountController = TextEditingController();
  bool isPaid = false;
  late String dateAndTime;
  late String dExpireDate;
  late String tre;
  late String ppAmount;
  late String ppBillReference;
  late String ppDescription;
  late String ppLanguage;
  late String ppMerchantID;
  late String ppPassword;
  late String ppReturnURL;
  late String ppVer;
  late String ppTxnCurrency;
  late String ppTxnDateTime;
  late String ppTxnExpiryDateTime;
  late String ppTxnRefNo;
  late String ppTxnType;
  late String ppmpf1;
  late String integritySalt;
  late String and;
  late String superData;
  late DateTime selectedDate;
  bool isLoading = false;
  late final String femail;
  late final int routeNo;
  late final String userName;

  @override
  void initState() {
    super.initState();
    dateAndTime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    dExpireDate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(const Duration(days: 1)));
    tre = "T$dateAndTime";

  //Your dummy transaction data here

  }

  Future<void> payment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    var key = utf8.encode(integritySalt);
    var bytes = utf8.encode(superData);
    var hmacSha256 = Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    String url =
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    var response = await http.post(Uri.parse(url), body: {
      "pp_Version": ppVer,
      "pp_TxnType": ppTxnType,
      "pp_Language": ppLanguage,
      "pp_MerchantID": ppMerchantID,
      "pp_Password": ppPassword,
      "pp_TxnRefNo": tre,
      "pp_Amount": ppAmount,
      "pp_TxnCurrency": ppTxnCurrency,
      "pp_TxnDateTime": dateAndTime,
      "pp_BillReference": ppBillReference,
      "pp_Description": ppDescription,
      "pp_TxnExpiryDateTime": dExpireDate,
      "pp_ReturnURL": ppReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": "4456733833993"
    });

    print("response=>");
    print(response.body);
    if (response.statusCode == 200) {
      var res = await response.body;
      var body = jsonDecode(res);
      var responsePrice = body['pp_Amount'];
      await MongoDatabase.updateFeeStatus(femail, 'paid');
      insertPaymentDetails(
        userName,
        femail,
        tre,
        routeNo,
        DateTime.now(),
      );
      isPaid = true;
      Navigator.pop(context);
      //Fluttertoast.showToast(msg: "Payment successful: $responsePrice");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransportFeeSlipScreen(
            name: userName,
            femail: femail,
            routeNumber: routeNo,
            transactionid: tre,
            transactiondate: DateTime.now(),
          ),
        ),
      );

    } else {
      Navigator.pop(context);
      nameController.clear();
      routenocontroller.clear();
      rollNoController.clear();
      sectioncontroller.clear();
      void showSnackBar(BuildContext context) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Failed!'),
            duration: Duration(seconds: 2),
          ),
        );
      }


    }

    setState(() {
      isLoading = false;
    });
    // Close the dialog
  }

  Future<void> insertPaymentDetails(String name,String femail,
      String transactionId, int routeno, DateTime transactionDate) async {
    final data = TransportFeeDetails(
      name: name,
      femail:femail,
      transactionid: transactionId,
      routeno: routeno,
      transactiondate: transactionDate,
    );
    await MongoDatabase.inserttransportpayment(data);
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize femail
  }
  @override
  Widget build(BuildContext context) {
    userName = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['userName'];
    femail = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['femail'];
    routeNo = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['routeNo'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Fee Deposit', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: $userName',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'Roll No: $femail',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'Route Number: $routeNo',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Text(
                'Transport Pass: Rs. 30000',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!isPaid) {
                    if (nameController.text.isEmpty ||
                        routenocontroller.text.isEmpty ||
                        rollNoController.text.isEmpty ||
                        sectioncontroller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please fill in all the fields')),
                      );
                    } else {
                      // Call JazzCash payment logic
                      // If payment successful, update isPaid to true
                      payment();
                      print('Payment processing...');

                    }
                    // Update payment status in database
                    // Display payment confirmation message
                    // Optionally, navigate to a success screen
                  } else {}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, size: 28),
                    SizedBox(width: 10),
                    Text(
                      isPaid ? 'Fee Paid' : 'Pay with JazzCash',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03314B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (isPaid)
                Text(
                  'Payment Status: Paid',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
