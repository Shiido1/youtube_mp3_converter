import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/change_password/provider/change_password_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final email;

  ChangePassword({Key key, this.email}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  String otpPin;
  ChangePasswordProvider changePasswordProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    changePasswordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    changePasswordProvider.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          title: TextViewWidget(
            text: 'Update Password',
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'An OTP has been sent to the provided email. Please use the OTP to reset your password',
                  style:
                      TextStyle(color: Colors.white, height: 1.6, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                textField(passwordController, 'New Password'),
                textField(cPasswordController, 'Re-type Password'),
                PinEntryTextField(
                  showFieldAsBox: false,
                  isTextObscure: false,

                  fields: 4,

                  onSubmit: (String pin) {
                    setState(() {
                      otpPin = pin;
                    });
                  }, // end onSubmit
                ),
                Center(
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.bottomRed,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            otpPin != null &&
                            otpPin.isNotEmpty)
                          _submitOtp(otpPin, passwordController.text,
                              cPasswordController.text);
                      },
                      child: Text(
                        'Update Password',
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
      ),
    );
  }

  void _submitOtp(
    String pin,
    String password,
    String cPassword,
  ) async {
    final map = {
      "password": password,
      "cpassword": cPassword,
      "email": widget.email,
      "OTP": pin
    };
    changePasswordProvider.otp(map);
  }

  Widget textField(TextEditingController _controller, String hint) => Theme(
        data: new ThemeData(hintColor: AppColor.white),
        child: TextFormField(
          style: TextStyle(color: AppColor.white),
          controller: _controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) {
            if (hint == 'New Password') {
              return val.isEmpty
                  ? 'Password cannot be empty'
                  : !isPasswordCompliant(val)
                      ? 'Passowrd must contain atleast 8 alphanumeric characters'
                      : null;
            } else {
              return val.isEmpty
                  ? 'Password cannot be empty'
                  : passwordController.text != val
                      ? 'Passwords do not match'
                      : !isPasswordCompliant(val)
                          ? 'Passowrd must contain atleast 8 alphanumeric characters'
                          : null;
            }
          },
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: AppColor.white),
              ),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: AppColor.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: AppColor.white),
              ),
              hintText: hint,
              focusColor: AppColor.white,
              hoverColor: AppColor.white),
        ),
      );
}
