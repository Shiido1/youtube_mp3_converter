import 'package:dots_indicator/dots_indicator.dart';
import'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  int currentIndexPage;
  int pageLength;

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RedBackground(
              iconButton: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: AppColor.white,
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainDashBoard()),
                ),
              ),
              text: 'Plan',
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50,top: 45),
              height: 400,
              child: PageView(
                onPageChanged: (value) {
                  setState(() => currentIndexPage = value);
                },
                children: <Widget>[
                  paymentContainer(
                    picture: SvgPicture.asset(AppAssets.basic),
                    text1: 'UNLIMITED BASIC',
                    text2: '150MB DISK SPACE (MONTHLY)',
                    text3: '0.99',
                    subWidgetButton: (){},
                  ),
                  paymentContainer(
                    picture: SvgPicture.asset(AppAssets.medium),
                    text1: 'UNLIMITED MEDIUM',
                    text2: '1.5 GB DISK SPACE (MONTHLY)',
                    text3: '3.99',
                    subWidgetButton: (){},
                  ),
                  paymentContainer(
                    picture: SvgPicture.asset(AppAssets.advance),
                    text1: 'UNLIMITED ADVANCE',
                    text2: '10GB DISK SPACE (6 MONTHLY)',
                    text3: '20',
                    subWidgetButton: (){},
                  ),
                ],
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
              height: 66,
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
    VoidCallback subWidgetButton
  })=> Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
          Radius.circular(10) //                 <--- border radius here
      ),
      color: AppColor.fadedPink,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        picture,
        SizedBox(
          height: 26,
        ),
        TextViewWidget(
          text: text1 ?? '',
          textSize: 23,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
          color: AppColor.white,
        ),
        SizedBox(height: 15,),
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
          onTap: ()=>subWidgetButton,
          child: Container(
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.transparent,
              border: Border.all(
                  width: 1,color: AppColor.white
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //                 <--- border radius here
              ),
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
        SizedBox(height: 15,)

      ],
    ),
  );
}
