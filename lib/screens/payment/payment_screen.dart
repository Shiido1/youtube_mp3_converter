import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/paymentAssistant.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;
    init();

    super.initState();
  }

  init() async {
    await Provider.of<LoginProviders>(context, listen: false)
        .getSavedUserToken();
    await Provider.of<LoginProviders>(context, listen: false)
        .getSavedUserName();
    await Provider.of<LoginProviders>(context, listen: false)
        .getSavedUserEmail();
    email = Provider.of<LoginProviders>(context, listen: false).email;
    name = Provider.of<LoginProviders>(context, listen: false).name;
    userToken = Provider.of<LoginProviders>(context, listen: false).userToken;
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
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => MainDashBoard())),
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
                      text2: '150MB DISK SPACE (MONTHLY)',
                      text3: r'$0.99',
                      subWidgetButton: () async {
                        //TODO: Show loading widget

                        makePayment(amount: 0.99, storage: 150000000);
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.medium,
                          height: 60, width: 60),
                      text1: 'UNLIMITED MEDIUM',
                      text2: '1.5 GB DISK SPACE (MONTHLY)',
                      text3: r'$3.99',
                      subWidgetButton: () async {
                        makePayment(amount: 3.99, storage: 1500000000);
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(AppAssets.advance,
                          height: 60, width: 60),
                      text1: 'UNLIMITED ADVANCE',
                      text2: '10GB DISK SPACE (6 MONTHLY)',
                      text3: r'$20',
                      subWidgetButton: () async {
                        makePayment(amount: 20.0, storage: 10000000000);
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

    //TODO: remove this name
    String name = 'Undie Ebenezer';

    var trxResponse = await PaymentAssistant.processTransaction(
        amount: amount, context: context, email: email, name: name, ref: ref);

    if (trxResponse != 'Cancelled' && trxResponse != 'Failed') {
      PaymentAssistant.storePayment(
          context: context,
          // txRef: trxResponse['data']['flwRef'] != null &&
          //         trxResponse['data']['flwRef'].toString().isNotEmpty
          //     ? trxResponse['data']['flwRef']
          //     : trxResponse['data']['txRef'],
          // txRef: trxResponse['data']['raveRef'],
          txRef: trxResponse['data']['txRef'],
          amount: amount,
          txId: trxResponse['data']['id'].toString(),
          storage: storage,
          userToken: userToken);
    } else if (trxResponse == 'Failed') {
      showToast(context, message: 'Transaction Failed. Try again later');
    } else
      showToast(context, message: 'Transaction cancelled');
  }
}
