import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/paymentAssistant.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
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
  String publicKey = 'pk_test_20fed7e409eb5e0f01fb5be78a63b9576612a566';
  // String publicKey = 'pk_live_badd2f12087954f78aaaa51ac3142a7ba307daa3';

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
                  onPressed: () => Navigator.pop(context)
                  // MaterialPageRoute(builder: (_) => MainDashBoard())),
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
                      text2: '150MB DISK SPACE',
                      // text3: r'$0.99',
                      text3: '\u{20A6} 514.8',
                      subWidgetButton: () async {
                        makePayment(amount: 514.80, storage: 150000000);
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.medium,
                          height: 60, width: 60),
                      text1: 'UNLIMITED MEDIUM',
                      text2: '1.5 GB DISK SPACE',
                      // text3: r'$3.99',
                      text3: '\u{20A6} 2,074.8',
                      subWidgetButton: () async {
                        makePayment(amount: 2074.80, storage: 1500000000);
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.advance,
                          height: 60, width: 60),
                      text1: 'UNLIMITED ADVANCE',
                      text2: '10GB DISK SPACE',
                      // text3: r'$20',
                      text3: '\u{20A6} 10,400',
                      subWidgetButton: () async {
                        makePayment(amount: 10400.0, storage: 10000000000);
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
                position: double.parse(currentIndexPage.toString()),
                decorator: DotsDecorator(
                    color: AppColor.white,
                    activeColor: AppColor.bottomRed,
                    size: Size.square(8.0),
                    activeSize: Size.square(8.0)),
              ),
            ),
            SizedBox(
              height: 21,
            ),
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

  void makePayment({@required double amount, @required int storage}) async {
    var uuid = Uuid();
    String ref = uuid.v4();

    var trxResponse = await PaymentAssistant.processTransaction(
        amount: amount, context: context, email: email, name: name, ref: ref);
    print(trxResponse);

    if (trxResponse != 'Cancelled' && trxResponse != 'Failed') {
      bool status = await PaymentAssistant.storePayment(
          context: context,
          txRef: trxResponse['data']['reference'],
          amount: amount,
          txId: trxResponse['data']['reference'],
          storage: storage,
          userToken: userToken);
      if (status) {
        showToast(context, message: 'Transaction successful');
      } else
        showToast(context, message: 'Transaction failed');
    } else if (trxResponse == 'Failed') {
      showToast(context, message: 'Transaction failed. Try again later');
    } else
      showToast(context, message: 'Transaction cancelled');
  }
}
