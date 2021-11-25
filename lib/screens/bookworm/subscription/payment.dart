import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Payment {
  static Future<bool> storePayment(
      {BuildContext context,
      String txRef,
      double amount,
      String txId,
      String duration,
      String userToken,
      String paymentMethod}) async {
    String baseUrl = "https://youtubeaudio.com/api/book/storepayment";

    var body = jsonEncode({
      "tx_ref": txRef,
      "amount": amount,
      "transaction_id": txId,
      "duration": duration.toLowerCase(),
      "token": userToken,
      "type": 'book'
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
