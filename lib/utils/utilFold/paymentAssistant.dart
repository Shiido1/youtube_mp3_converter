import 'dart:convert';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentAssistant {
  static Future<bool> storePayment(
      {BuildContext context,
      String txRef,
      double amount,
      String txId,
      int storage,
      String userToken}) async {
    String baseUrl = "http://67.205.165.56/api/storepayment";

    var body = jsonEncode({
      "tx_ref": txRef,
      "amount": amount,
      "transaction_id": txId,
      "storage": storage,
      "token": userToken
    });

    try {
      final _response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      print(_response.statusCode);
      print('this isthe response: ${_response.body}');
      print('this is the decoded response: ${json.decode(_response.body)}');

      if (_response.statusCode == 200) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  static Future<dynamic> processTransaction(
      {@required BuildContext context,
      @required double amount,
      @required String email,
      @required String name,
      @required String ref}) async {
    Widget companyName = Text('YT Audio');
    // String publicKey = "FLWPUBK_TEST-916479768e98ba46f46d30c95b7589b2-X";
    // String encryptionKey = "FLWSECK_TESTe654c63ec08a";
    String publicKey = "FLWPUBK-7fef3984e211df005895564ef9de4230-X";
    String encryptionKey = "acbe6e050c01e3de032f788e";
    var initializer = RavePayInitializer(
        amount: amount, publicKey: publicKey, encryptionKey: encryptionKey)
      ..country = "NG"
      ..currency = 'USD'
      ..email = email
      ..fName = name.split(' ')[0]
      ..lName = name.split(' ').length > 1 ? name.split(' ')[1] : ''
      ..narration = 'Subscription Plan'
      ..txRef = ref
      ..subAccounts = []
      ..acceptMpesaPayments = false
      ..acceptAccountPayments = false
      ..acceptCardPayments = true
      ..acceptAchPayments = false
      ..acceptGHMobileMoneyPayments = false
      ..acceptUgMobileMoneyPayments = false
      ..staging = false
      ..companyName = companyName
      ..isPreAuth = false
      ..displayEmail = true
      ..displayFee = true;

    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer);

    RaveStatus txStatus = response.status;

    switch (txStatus) {
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
