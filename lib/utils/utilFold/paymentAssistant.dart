import 'package:rave_flutter/rave_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PaymentAssistant{
  // , double amount, String customerEmailAddress, String customerFName, String customerLName, String narration, String txRef
  static Future<dynamic>processTransaction(BuildContext context) async {
    // Get a reference to RavePayInitializer
    Widget companyName = Text('Youtube Audio');
    String publicKey = "FLWPUBK_TEST-eb59a5bc41b70eabbd718b5334202c0a-X";
    String encryptionKey = "FLWSECK_TEST2b05410cd196";
    var initializer = RavePayInitializer(
        amount: 500, publicKey: publicKey, encryptionKey: encryptionKey)
      ..country = "NG"
      ..currency = "NGN"
      ..email = 'oanthony590@gmail.com'
      ..fName = 'customerFName'
      ..lName = 'customerLName'
      ..narration = 'narration'
      ..txRef = 'txRef'
      ..subAccounts = []
      ..acceptMpesaPayments = false
      ..acceptAccountPayments = false
      ..acceptCardPayments = true
      ..acceptAchPayments = false
      ..acceptGHMobileMoneyPayments = false
      ..acceptUgMobileMoneyPayments = false
      ..staging = true
      ..companyName = companyName
      ..isPreAuth = false
      ..displayEmail = true
      ..displayFee = true;

    // Initialize and get the transaction result
    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer);

    RaveStatus txStatus = response.status;

    switch(txStatus){

      case (RaveStatus.success):
        return response.rawResponse;
        break;

      case (RaveStatus.error):
        return "Failed";
        break;

      case (RaveStatus.cancelled):
        return "Cancelled";
        break;
    }
  }

}
