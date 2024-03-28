import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  void initState() {
    super.initState();
    dateAndTime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    dExpireDate =
        DateFormat("yyyyMMddHHmmss").format(DateTime.now().add(const Duration(days: 1)));
    tre = "T$dateAndTime";

    ppAmount = "300";
    ppBillReference = "billRef";
    ppDescription = "Description for transaction";
    ppLanguage = "EN";
    ppMerchantID = "MC83924";
    ppPassword = "y40ytt9u62";
    ppReturnURL =
    "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    ppVer = "1.1";
    ppTxnCurrency = "PKR";
    ppTxnDateTime = dateAndTime;
    ppTxnExpiryDateTime = dExpireDate;
    ppTxnRefNo = tre;
    ppTxnType = "MWALLET";
    ppmpf1 = "4456733833993";
    integritySalt = "531d1z69at";
    and = '&';
    superData = integritySalt +
        and +
        ppAmount +
        and +
        ppBillReference +
        and +
        ppDescription +
        and +
        ppLanguage +
        and +
        ppMerchantID +
        and +
        ppPassword +
        and +
        ppReturnURL +
        and +
        ppTxnCurrency +
        and +
        ppTxnDateTime +
        and +
        ppTxnExpiryDateTime +
        and +
        ppTxnRefNo +
        and +
        ppTxnType +
        and +
        ppVer +
        and +
        ppmpf1;
    selectedDate = DateTime.now().add(Duration(days: 1));
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
    String url = 'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

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
          nameController.text,
          rollNoController.text,
          sectionController.text,
          int.parse(routeNoController.text),
          tre,
          DateTime.now(),
          selectedDate);
      Navigator.pop(context);
     /* nameController.clear();
      routeNoController.clear();
      rollNoController.clear();
      sectionController.clear();*/
      Fluttertoast.showToast(msg: "Payment successful: $responsePrice");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusPassScreen(
            name: nameController.text,
            rollNo: rollNoController.text,
            section: sectionController.text,
            routeNumber: int.parse(routeNoController.text),
            travelDate: selectedDate,
            transactionid: tre,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Payment failed");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> insertPaymentDetails(String name, String rollNo, String section,
      int routeno, String transactionId, DateTime transactionDate, DateTime travelDate) async {
    final data = PaymentDetails(
        name: name,
        rollno: rollNo,
        section: section,
        routeno: routeno,
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
              TextField(
                controller: nameController,
                maxLength: 25,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: const Color.fromARGB(27, 0, 0, 0),
                  filled: true,
                  hintText: "Hostelite Student Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: rollNoController,
                maxLength: 25,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: const Color.fromARGB(27, 0, 0, 0),
                  filled: true,
                  hintText: "Roll Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: sectionController,
                maxLength: 25,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: const Color.fromARGB(27, 0, 0, 0),
                  filled: true,
                  hintText: "Section",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: routeNoController,
                maxLength: 25,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: const Color.fromARGB(27, 0, 0, 0),
                  filled: true,
                  hintText: "Route Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 20),
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
