import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/signup/sign_up_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _isEmail = false;
  bool _isPassword = false;
  LoginProviders _loginProviders;
  SharedPreferences loginPref;
  bool newUser;

  // void checkLogin() async {
  //   loginPref = await SharedPreferences.getInstance();
  //   newUser = (loginPref.getBool('login') ?? true);
  //
  //   if (newUser == false) {
  //     PageRouter.gotoNamed(Routes.DASHBOARD, context);
  //   }
  // }

  void signIn(BuildContext context, String email, String password) {
    if (_validateInputs())
      _loginProviders.loginUser(
          map: LoginModel.toJson(email: email, password: password),
          context: context);
  }

  bool _validateInputs() {
    if (_emailController.text.isEmpty ||
        !validateEmail(_emailController.text)) {
      setState(() => _isEmail = true);
      return false;
    }

    if (_passwordController.text.isEmpty ||
        !isPasswordCompliant(_passwordController.text)) {
      setState(() => _isPassword = true);
      return false;
    }

    return true;
  }

  @override
  void initState() {
    // checkLogin();
    _loginProviders = Provider.of<LoginProviders>(context, listen: false);
    _loginProviders.initialize(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProviders>(
        builder: (_, model, __) {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                color: AppColor.black,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      AppColor.black.withOpacity(0.5), BlendMode.dstATop),
                  image: new AssetImage(
                    AppAssets.bgImage2,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 65),
                    Image.asset(
                      AppAssets.logo,
                    ),
                    SizedBox(height: 35),
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                          color: AppColor.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 105),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0, left: 35.0),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(color: AppColor.white),
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: AppColor.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: AppColor.white),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: AppColor.white),
                          ),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: AppColor.white),
                          errorText: _isEmail
                              ? 'Please enter correct email address'
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0, left: 35.0),
                      child: TextField(
                        controller: _passwordController,
                        style: TextStyle(color: AppColor.white),
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: AppColor.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: AppColor.white),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: AppColor.white),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColor.white),
                          errorText: _isPassword
                              ? 'Please enter correct password'
                              : null,
                        ),
                        autofocus: false,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 35),
                    model.isLoading
                        ? SpinKitCircle(
                            color: AppColor.white,
                            size: 50.0,
                          )
                        : TextButton(
                        style: TextButton
                            .styleFrom(
                          backgroundColor: AppColor
                              .bottomRed,
                        ),
                            onPressed: () {
                              signIn(context, _emailController.text.trim(),
                                  _passwordController.text.trim());
                              // if (_emailController.text != '' &&
                              //     _passwordController.text != '') {
                              //   loginPref.setBool('login', false);
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, right: 23, left: 23),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 22,
                                ),
                              ),
                            )),
                    SizedBox(height: 75),
                    Text(
                      'Don\'t have an Account?',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 35),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColor.bottomRed,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
