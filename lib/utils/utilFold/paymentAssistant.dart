import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
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
      String userToken,
      String paymentMethod}) async {
    String baseUrl = "http://159.223.129.191/api/storepayment";

    var body = jsonEncode({
      "tx_ref": txRef,
      "amount": amount,
      "transaction_id": txId,
      "storage": storage,
      "token": userToken,
      "payment_method": paymentMethod
    });

    try {
      final _response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      final decodedResponse = jsonDecode(_response.body);
      print(decodedResponse);

      if (_response.statusCode == 200 &&
          decodedResponse['message']
              .toString()
              .toLowerCase()
              .contains('success')) {
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
    CustomProgressIndicator _progressIndicator =
        CustomProgressIndicator(context);

    DataSnapshot secretKey = await FirebaseDatabase.instance
        .reference()
        .child('keys')
        .child('live')
        .once();

// Secret: sk_test_024d9f465d18b515259d28b1518471c0c230156d
// Public: pk_test_20fed7e409eb5e0f01fb5be78a63b9576612a566

// Secret: sk_live_3a385f102ace7cef82c12b216b31ae8fe4bb4155
// Public: pk_live_badd2f12087954f78aaaa51ac3142a7ba307daa3

    Charge charge = Charge();
    charge
      ..card = PaymentCard(
          number: null, cvc: null, expiryMonth: null, expiryYear: null)
      ..amount = (amount * 100).toInt()
      ..email = email
      ..reference = ref;

    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      charge: charge,
      method: CheckoutMethod.card,
      fullscreen: false,
      logo: Container(
        width: 80,
        height: 60,
        child: Image.asset('assets/youtubeaudiologo.png'),
      ),
    );

    if (response.status == true) {
      _progressIndicator.show();
      var val = await verifyTransaction(
          ref: response.reference,
          key: secretKey.value,
          amount: charge.amount,
          context: context);

      _progressIndicator.dismiss();
      return val;
    }
    return 'Cancelled';
    //   Widget companyName = Text('YT Audio');
    //   // String publicKey = "FLWPUBK_TEST-916479768e98ba46f46d30c95b7589b2-X";
    //   // String encryptionKey = "FLWSECK_TESTe654c63ec08a";
    //   String publicKey = "FLWPUBK-7fef3984e211df005895564ef9de4230-X";
    //   String encryptionKey = "acbe6e050c01e3de032f788e";
    //   var initializer = RavePayInitializer(
    //       amount: amount, publicKey: publicKey, encryptionKey: encryptionKey)
    //     ..country = "NG"
    //     ..currency = 'USD'
    //     ..email = email
    //     ..fName = name.split(' ')[0]
    //     ..lName = name.split(' ').length > 1 ? name.split(' ')[1] : ''
    //     ..narration = 'Subscription Plan'
    //     ..txRef = ref
    //     ..subAccounts = []
    //     ..acceptMpesaPayments = false
    //     ..acceptAccountPayments = false
    //     ..acceptCardPayments = true
    //     ..acceptAchPayments = false
    //     ..acceptGHMobileMoneyPayments = false
    //     ..acceptUgMobileMoneyPayments = false
    //     ..staging = false
    //     ..companyName = companyName
    //     ..isPreAuth = false
    //     ..displayEmail = true
    //     ..displayFee = true;

    //   RaveResult response = await RavePayManager()
    //       .prompt(context: context, initializer: initializer);

    //   RaveStatus txStatus = response.status;

    //   switch (txStatus) {
    //     case (RaveStatus.success):
    //       return response.rawResponse;
    //       break;

    //     case (RaveStatus.error):
    //       return "Failed";
    //       break;

    //     case (RaveStatus.cancelled):
    //       return "Cancelled";
    //       break;
    //   }
  }
}

Future<dynamic> verifyTransaction(
    {@required String ref,
    @required String key,
    @required int amount,
    @required BuildContext context}) async {
  String url = 'https://api.paystack.co/transaction/verify/' + ref;
  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $key'
  };

  try {
    final response = await get(url, headers: header);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      print(data);
      if (data['data']['status'].toString().toLowerCase().trim() == 'success')
        return data;
      else
        return 'Failed';
    } else {
      return 'Failed';
    }
  } catch (e) {
    return 'Failed';
  }
}
