import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/change_password/provider/change_password_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = new TextEditingController();
  ChangePasswordProvider changePasswordProvider;

  @override
  void initState() {
    changePasswordProvider = Provider.of<ChangePasswordProvider>(context, listen: false);
    changePasswordProvider.init(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          title: TextViewWidget(
            text: 'Forgot Password',
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              textField(controller:emailController, hint:'Email Address'),
              Center(
                child: TextButton(
                    style: TextButton
                        .styleFrom(
                      backgroundColor: AppColor
                          .bottomRed,
                    ),
                    onPressed: ()=>sendEmail(),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 20,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
  void sendEmail(){
    if (emailController.text.isEmpty) {
      showToast(context, message: "Please input a valid email address");
    } else {
      changePasswordProvider.emailOtp('${emailController.text.trim()}');
    }
  }

  Widget textField({TextEditingController controller,String hint})=>Theme(
    data: new ThemeData(hintColor: AppColor.white),
    child: TextField(
        style: TextStyle(color: AppColor.white),
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppColor.white),
            ),
            border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppColor.white),
            ),
            hintText: hint,
            focusColor: AppColor.white,
            hoverColor: AppColor.white)),
  );
}
