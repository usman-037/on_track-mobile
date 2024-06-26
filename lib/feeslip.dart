import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'BusPassScreen.dart';
import 'dbHelper/mongodb.dart';

class FeesSlipScreen extends StatefulWidget {
  @override
  _FeesSlipScreenState createState() => _FeesSlipScreenState();
}

class _FeesSlipScreenState extends State<FeesSlipScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController routeNoController = TextEditingController();

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
  late final String userName;

  @override
  void initState() {
    super.initState();
    dateAndTime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    dExpireDate =
        DateFormat("yyyyMMddHHmmss").format(DateTime.now().add(const Duration(days: 1)));
    tre = "T$dateAndTime";

  //Your dummy transaction details here
  }

  Future<void> payment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    var key = utf8.encode(integritySalt);
    var bytes = utf8.encode(superData);
    var hmacSha256 = Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
  

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
      insertPaymentDetails(
          userName,
         femail,
          tre,
          DateTime.now(),
          selectedDate);
      Navigator.pop(context);
    
      void showSnackBar(BuildContext context) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusPassScreen(
            name: nameController.text,
            femail: femail,
            routeNumber: int.parse(routeNoController.text),
            travelDate: selectedDate,
            transactionid: tre,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
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
  }

  Future<void> insertPaymentDetails(String name, String femail,
 String transactionId, DateTime transactionDate, DateTime travelDate) async {
    final data = PaymentDetails(
        name: name,
       femail:femail,
        transactionid: transactionId,
        transactiondate: transactionDate,
        traveldate: travelDate);
    await MongoDatabase.insertpayment(data);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime nextDay = currentDate.add(Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDate,
      lastDate: nextDay,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userName = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['userName'];
    femail = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['femail'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Pass Form', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: $userName',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10),
              Text(
                'Roll No: $femail',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Travel Date:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_today, color: Colors.blue),
                      label: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Transport Pass: Rs. 300',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                        if (nameController.text.isEmpty ||
                            routeNoController.text.isEmpty||rollNoController.text.isEmpty||sectionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please fill in all the fields')),
                          );
                        }
                        else {

                          payment();

                          print('Payment processing...');
                        }



                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'Pay with JazzCash',
                          style: TextStyle(fontSize: 18.0,color:Colors.white,
                        ),

                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFF03314B),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
