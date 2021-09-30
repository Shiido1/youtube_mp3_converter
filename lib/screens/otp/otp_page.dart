import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/otp/model/otp_model.dart';
import 'package:mp3_music_converter/screens/otp/provider/otp_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/timer_helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String userID;

  OtpPage({@required this.email, @required this.userID});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  OtpProviders _otpProviders;
  UtilityProvider _utilityProvider;

  String pin = '';

  @override
  void initState() {
    _otpProviders = Provider.of<OtpProviders>(context, listen: false);
    _utilityProvider = Provider.of<UtilityProvider>(context, listen: false);
    _utilityProvider.startTimer(timeLimit: 4);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pin = '';
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.black,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Platform.isAndroid
                ? Icon(
                    Icons.arrow_back,
                    color: AppColor.bottomRed,
                  )
                : Icon(
                    Icons.navigate_before,
                    color: AppColor.bottomRed,
                  ),
            onPressed: () => PageRouter.goBack(context)),
      ),
      body: SingleChildScrollView(
        child: Consumer<UtilityProvider>(
          builder: (_, util, __) => Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextViewWidget(
                    text:
                        'A verification code has been sent to your provided Email Address.',
                    color: AppColor.white,
                    textSize: 18,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 77, right: 77),
                    child: TextViewWidget(
                      text: 'Please check your email and type the code below.',
                      color: AppColor.white,
                      textSize: 16,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  PinEntryTextField(
                    showFieldAsBox: false,
                    isTextObscure: false,
                    fields: 6,
                    onSubmit: (String pin) =>
                        _submitOtp(pin, util), // end onSubmit
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: util.timerIsNotExpired
                            ? 'Resend OTP in:  '
                            : 'I did\'t receive the code.  ',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColor.white,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => util.timerIsNotExpired
                                  ? null
                                  : _otpProviders.resendOtp(
                                      email: email, context: context),
                            text: util.timerIsNotExpired
                                ? '0${util.minute} : ${util.seconds.toString().length == 1 ? '0${util.seconds}' : util.seconds}'
                                : 'Resend OTP',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitOtp(
    String pin,
    UtilityProvider util,
  ) {
    setState(() => userId = widget.userID);
    _otpProviders.verifyOtp(
        map: OtpModel.toJson(otp: int.parse(pin), email: email),
        context: context);
  }
}
