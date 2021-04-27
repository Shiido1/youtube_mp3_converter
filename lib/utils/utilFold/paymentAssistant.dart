import 'dart:convert';

import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class PaymentAssistant{

  static Future<bool> storePayment(BuildContext context, String txRef, int amount, String txId, int storage, String userToken) async{
    String baseUrl = "http://67.205.165.56/api/storepayment";
    var body = jsonEncode({
        "tx_ref": txRef,
        "amount":amount,
        "transaction_id":txId,
        "storage":storage,
        "token":userToken
    });

    try {
      final _response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (_response.statusCode == 200) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      return Future.value(false);
    }
  }


  static Future<dynamic>processTransaction(
      BuildContext context,
      double _amount,
      String customerEmailAddress,
      String customerFName,
      // String narration,
      // String txRef
      ) async {
    // Get a reference to RavePayInitializer
    Widget companyName = Text('Youtube Audio');
    String publicKey = "FLWPUBK_TEST-eb59a5bc41b70eabbd718b5334202c0a-X";
    String encryptionKey = "FLWSECK_TEST2b05410cd196";
    var initializer = RavePayInitializer(
        amount: _amount, publicKey: publicKey, encryptionKey: encryptionKey)
      ..country = "NG"
      ..currency = 'USD'
      ..email = customerEmailAddress
      ..fName = customerFName
      ..lName = 'customerLName'
      ..narration = 'narration'
      ..txRef = 'transaction reference'
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
