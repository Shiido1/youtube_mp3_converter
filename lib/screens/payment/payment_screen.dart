import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/paymentAssistant.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int currentIndexPage;
  int pageLength;
  String email = '';
  String name = '';
  String userToken = '';
  String publicKey = 'pk_live_badd2f12087954f78aaaa51ac3142a7ba307daa3';
  // String publicKey = 'pk_test_20fed7e409eb5e0f01fb5be78a63b9576612a566';
  FlutterPay flutterPay = FlutterPay();

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;

    init();

    super.initState();
  }

  init() async {
    email = await preferencesHelper.getStringValues(key: 'email');
    name = await preferencesHelper.getStringValues(key: 'name');
    userToken = await preferencesHelper.getStringValues(key: 'token');
    PaystackPlugin.initialize(publicKey: publicKey);
    await AudioService.stop();
    print('is playing : ${AudioService?.running}');
  }

  @override
  void dispose() {
    PaystackPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Container(
        child: Column(
          children: [
            RedBackground(
              iconButton: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: AppColor.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              text: 'Plan',
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 45),
                height: 400,
                child: PageView(
                  onPageChanged: (value) {
                    setState(() => currentIndexPage = value);
                  },
                  children: <Widget>[
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.basic,
                          height: 60, width: 60),
                      text1: 'UNLIMITED BASIC',
                      text2: '3 SONGS (MONTHLY)',
                      text3: r'$0.99',
                      // text3: Platform.isAndroid ? '\u{20A6} 499' : r'$0.99',
                      subWidgetButton: () async {
                        makePayment(
                            amount: Platform.isAndroid ? 499.0 : 0.99,
                            storage: 150000000,
                            title: '3 SONGS (MONTHLY)');
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.medium,
                          height: 60, width: 60),
                      text1: 'UNLIMITED MEDIUM',
                      text2: '8 SONGS (MONTHLY)',
                      text3: r'$1.99',
                      // text3: Platform.isAndroid ? '\u{20A6} 1,499' : r'$3.99',
                      subWidgetButton: () async {
                        makePayment(
                            amount: Platform.isAndroid ? 999.0 : 1.99,
                            storage: 1500000000,
                            title: '8 SONGS (MONTHLY)');
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.advance,
                          height: 60, width: 60),
                      text1: 'UNLIMITED ADVANCE',
                      text2: 'UNLIMITED SONGS (MONTHLY)',
                      text3: r'$20',
                      // text3: Platform.isAndroid ? '\u{20A6} 9,999' : r'$20',
                      subWidgetButton: () async {
                        makePayment(
                            amount: Platform.isAndroid ? 9999.0 : 20.0,
                            storage: 10000000000,
                            title: 'UNLIMITED SONGS (MONTHLY)');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 21,
            ),
            Center(
              child: DotsIndicator(
                dotsCount: pageLength,
                position: double.parse(
                  currentIndexPage.toString(),
                ),
                decorator: DotsDecorator(
                    color: AppColor.white,
                    activeColor: AppColor.bottomRed,
                    size: Size.square(8.0),
                    activeSize: Size.square(8.0)),
              ),
            ),
            SizedBox(height: 21),
          ],
        ),
      ),
    );
  }

  Widget paymentContainer({
    SvgPicture picture,
    String text1,
    String text2,
    String text3,
    VoidCallback subWidgetButton,
  }) =>
      Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppColor.white,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    picture,
                    TextViewWidget(
                      text: text1 ?? '',
                      textSize: 23,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      color: AppColor.bottomRed,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextViewWidget(
                      text: text2 ?? '',
                      textSize: 17,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                    TextViewWidget(
                      text: text3 ?? '',
                      textSize: 22,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      color: AppColor.bottomRed,
                    ),
                    InkWell(
                      onTap: subWidgetButton,
                      child: Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColor.transparent,
                          border:
                              Border.all(width: 1, color: AppColor.bottomRed),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Center(
                          child: TextViewWidget(
                              color: AppColor.black,
                              text: 'BUY',
                              textSize: 25,
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  void makePayment(
      {@required double amount,
      @required int storage,
      @required String title}) async {
    if (Platform.isAndroid) {
      cardPayment(amount: amount, storage: storage);
    } else if (Platform.isIOS) {
      applePayment(amount: amount, storage: storage, title: title);
    }
  }

  void cardPayment({@required double amount, @required int storage}) async {
    var uuid = Uuid();
    String ref = uuid.v4();

    var trxResponse = await PaymentAssistant.processTransaction(
        amount: amount, context: context, email: email, name: name, ref: ref);
    print(trxResponse);

    if (trxResponse != 'Cancelled' && trxResponse != 'Failed') {
      print(trxResponse['data']['reference']);
      bool status = await PaymentAssistant.storePayment(
          context: context,
          txRef: trxResponse['data']['reference'],
          amount: amount,
          txId: trxResponse['data']['reference'],
          storage: storage,
          userToken: userToken,
          paymentMethod: 'card');
      if (status)
        showToast(context,
            message: 'Payment successful',
            duration: 7,
            backgroundColor: Colors.green);
      else
        showToast(context, message: 'Payment failed', duration: 7);
    } else if (trxResponse == 'Failed') {
      showToast(context,
          message: 'Transaction Failed. Try again later', duration: 5);
    } else {
      showToast(context, message: 'Transaction cancelled', duration: 5);
    }
  }

  void applePayment(
      {@required double amount,
      @required int storage,
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

        PaymentAssistant.storePayment(
            context: context,
            txRef: "",
            amount: amount,
            txId: "",
            storage: storage,
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
}
