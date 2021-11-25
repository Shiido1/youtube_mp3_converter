import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:mp3_music_converter/screens/bookworm/subscription/payment.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:uuid/uuid.dart';

class Subscription extends StatefulWidget {
  Subscription();

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  String email = '';
  String name = '';
  String userToken = '';
  String publicKey = 'pk_live_badd2f12087954f78aaaa51ac3142a7ba307daa3';
  // String publicKey = 'pk_test_20fed7e409eb5e0f01fb5be78a63b9576612a566';
  FlutterPay flutterPay = FlutterPay();

  init() async {
    email = await preferencesHelper.getStringValues(key: 'email');
    name = await preferencesHelper.getStringValues(key: 'name');
    userToken = await preferencesHelper.getStringValues(key: 'token');
    PaystackPlugin.initialize(publicKey: publicKey);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    PaystackPlugin.dispose();
    super.dispose();
  }

  void makePayment(
      {@required double amount,
      @required String duration,
      @required String title}) async {
    if (Platform.isAndroid) {
      makeCardPayment(amount: amount, duration: duration);
    } else if (Platform.isIOS) {
      makeApplePayment(amount: amount, duration: duration, title: title);
    }
  }

  void makeCardPayment(
      {@required double amount, @required String duration}) async {
    var uuid = Uuid();
    String ref = uuid.v4();

    var trxResponse = await Payment.processTransaction(
        amount: amount, context: context, email: email, name: name, ref: ref);
    print(trxResponse);

    if (trxResponse != 'Cancelled' && trxResponse != 'Failed') {
      print(trxResponse['data']['reference']);
      bool status = await Payment.storePayment(
          context: context,
          txRef: trxResponse['data']['reference'],
          amount: amount,
          txId: trxResponse['data']['id'].toString(),
          duration: duration,
          userToken: userToken,
          paymentMethod: 'card');
      if (status) {
        showToast(
          context,
          message: 'Payment successful',
          duration: 7,
          backgroundColor: Colors.green,
        );
        Navigator.pop(context);
      } else
        showToast(
          context,
          message: 'Payment failed',
          duration: 7,
          backgroundColor: Colors.red,
        );
    } else if (trxResponse == 'Failed') {
      showToast(
        context,
        message: 'Transaction Failed. Try again later',
        duration: 5,
        backgroundColor: Colors.red,
      );
    } else {
      showToast(
        context,
        message: 'Transaction cancelled',
        duration: 5,
        backgroundColor: Colors.red,
      );
    }
  }

  void makeApplePayment(
      {@required double amount,
      @required String duration,
      @required String title}) async {
    List<PaymentItem> items = [PaymentItem(name: title, price: amount)];

    try {
      bool result = await flutterPay.canMakePayments();

      if (result) {
        flutterPay.setEnvironment(
            environment: kReleaseMode
                ? PaymentEnvironment.Production
                : PaymentEnvironment.Test);

        var paymentToken = await flutterPay.requestPayment(
          appleParameters: AppleParameters(
            merchantIdentifier: "merchant.youtubeaudio.app",
          ),
          currencyCode: "USD",
          countryCode: "US",
          paymentItems: items,
        );

        Payment.storePayment(
            context: context,
            txRef: "",
            amount: amount,
            txId: "",
            duration: duration,
            userToken: userToken,
            paymentMethod: 'applepay');
      } else {
        showToast(context,
            message:
                "You are not allowed to make payment, please review your account settings.");
      }
    } catch (e) {
      print(['applePayment exception', e.toString()]);

      showToast(context, message: 'Transaction Failed. Try again later');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white.withOpacity(0.05),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Bookworm Plans',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            _planContainer(
              name: 'plan a',
              description: 'Unlimited Books (Monthly)',
              price: 1.99,
              buy: () {
                makePayment(
                    amount: Platform.isAndroid ? 999.0 : 1.99,
                    duration: 'monthly',
                    title: 'Unlimited Books (Monthly)');
              },
            ),
            _planContainer(
              name: 'plan b',
              description: 'Unlimited Books (Yearly)',
              price: 10,
              buy: () {
                makePayment(
                    amount: Platform.isAndroid ? 4999.0 : 10.0,
                    duration: 'yearly',
                    title: 'Unlimited Books (Yearly)');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _planContainer(
      {@required String name,
      @required String description,
      @required dynamic price,
      @required VoidCallback buy}) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(
              maxHeight: 300, maxWidth: 250, minHeight: 200, minWidth: 180),
          padding: EdgeInsets.all(30),
          alignment: Alignment.center,
          margin: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: [
            Text(
              name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900]),
            ),
            Spacer(),
            Text(
              description.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Spacer(),
            Text(
              '\$$price',
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900]),
            ),
            Spacer(),
            GestureDetector(
              onTap: buy,
              child: Container(
                alignment: Alignment.center,
                width: 80,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[900]),
                ),
                child: Text(
                  'BUY',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
