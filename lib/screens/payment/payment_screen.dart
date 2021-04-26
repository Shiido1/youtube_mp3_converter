import 'package:dots_indicator/dots_indicator.dart';
import'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/paymentAssistant.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  int currentIndexPage;
  int pageLength;
  double amount;
  var email='';
  var name='';

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;
    email = Provider.of<LoginProviders>(context,listen: false).email;
    // email = 'uwahsheedo@gmail.com';
    name =  Provider.of<LoginProviders>(context,listen: false).name;
    super.initState();
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
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainDashBoard()),
                ),
              ),
              text: 'Plan',
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 50, right: 50,top: 45),
                height: 400,
                child: PageView(
                  onPageChanged: (value) {
                    setState(() => currentIndexPage = value);
                  },
                  children: <Widget>[
                    paymentContainer(
                      picture: SvgPicture.asset(
                          AppAssets.basic,
                          height: 60,
                          width: 60),
                      text1: 'UNLIMITED BASIC',
                      text2: '150MB DISK SPACE (MONTHLY)',
                      text3: r'$0.99',
                      amount: amount,
                      subWidgetButton: () async{
                        //TODO: Show loading widget
                        print('About to pay mr $name with email $email');
                        var trxResponse =
                        await PaymentAssistant.processTransaction(
                            context,1.0,
                            email, name,                          // 'jhjkjkkj','jhjkhjkh'
                        );
                        if(trxResponse != 'Cancelled' && trxResponse != 'Failed'){
                          print(trxResponse);
                          print('Transaction successful');
                        }else if(trxResponse == 'Failed'){
                          print('Transaction Failed. Try again later');
                        }
                        else
                          print('Transaction Cancelled');

                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(
                          AppAssets.medium,
                          height: 60,
                          width: 60),
                      text1: 'UNLIMITED MEDIUM',
                      text2: '1.5 GB DISK SPACE (MONTHLY)',
                      text3: r'$3.99',
                      amount: amount,
                      subWidgetButton: () async{
                        var trxResponse =
                        await PaymentAssistant.processTransaction(
                            context,3.99,
                          email, name,
                        );
                        if(trxResponse != 'Cancelled' && trxResponse != 'Failed'){
                          print(trxResponse);
                          print('Transaction successful');
                        }else if(trxResponse == 'Failed'){
                          print('Transaction Failed. Try again later');
                        }
                        else
                          print('Transaction Cancelled');
                      },
                    ),
                    paymentContainer(
                      picture: SvgPicture.asset(
                          AppAssets.advance,
                          height: 60,
                          width: 60),
                      text1: 'UNLIMITED ADVANCE',
                      text2: '10GB DISK SPACE (6 MONTHLY)',
                      text3: r'$20',
                      amount: amount,
                      subWidgetButton: ()async{
                        var trxResponse =
                        await PaymentAssistant.processTransaction(
                            context,20.0,
                          email, name,
                        );
                        if(trxResponse != 'Cancelled' && trxResponse != 'Failed'){
                          print(trxResponse);
                          print('Transaction successful');
                        }else if(trxResponse == 'Failed'){
                          print('Transaction Failed. Try again later');
                        }
                        else
                          print('Transaction Cancelled');
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
    // , double amount, String customerEmailAddress, String customerFName, String customerLName, String narration, String txRef
    double amount,
    String customerEmailAddress,
    String customerFName,
    // String narration,
    // String txRef,
  })=> Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
          Radius.circular(10) //                 <--- border radius here
      ),
      color: AppColor.white,
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
          color: AppColor.bottomRed,
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
          onTap: subWidgetButton,
          child: Container(
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.transparent,
              border: Border.all(
                  width: 1,color: AppColor.bottomRed
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
