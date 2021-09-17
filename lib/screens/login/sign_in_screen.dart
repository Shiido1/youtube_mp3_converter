import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mp3_music_converter/screens/change_password/forgot_password_email_screen.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/screens/signup/sign_up_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:provider/provider.dart';

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
  SharedPreferencesHelper preferencesHelper;
  bool newUser;
  String email, password;

  void signIn(BuildContext context, String email, String password) {
    if (_validateInputs())
      _loginProviders.loginUser(
          map: LoginModel.toJson(email: email, password: password),
          context: context);
  }

  void googleSignIn() async {
    GoogleSignIn googleSign = GoogleSignIn(scopes: ['email', 'profile']);

    try {
      await googleSign.signIn();

      print(googleSign.currentUser.photoUrl);
      print(googleSign.currentUser.email);
      print(googleSign.currentUser.id);
      print(googleSign.currentUser.displayName);
    } catch (e) {
      print(e);
    }
  }

  bool _validateInputs() {
    if (_emailController.text.trim().isEmpty ||
        !validateEmail(_emailController.text.trim())) {
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
      backgroundColor: AppColor.black,
      body: Consumer<LoginProviders>(
        builder: (_, model, __) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: 55),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextField(
                              onChanged: (val) {
                                if (val.isNotEmpty)
                                  setState(() {
                                    _isEmail = false;
                                  });
                              },
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
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextField(
                              onChanged: (val) {
                                if (val.isNotEmpty)
                                  setState(() {
                                    _isPassword = false;
                                  });
                              },
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
                                    ? 'Please enter a correct 8 alphanumeric password'
                                    : null,
                              ),
                              autofocus: false,
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  googleSignIn();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.google,
                                  color: AppColor.bottomRed,
                                  size: 40,
                                ),
                              ),
                              SizedBox(width: 50),
                              model.isLoading
                                  ? SpinKitCircle(
                                      color: AppColor.white,
                                      size: 50.0,
                                    )
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColor.bottomRed,
                                      ),
                                      onPressed: () {
                                        signIn(
                                            context,
                                            _emailController.text.trim(),
                                            _passwordController.text.trim());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            right: 23,
                                            left: 23),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColor.bottomRed,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 45),
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
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
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
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),);
        },
      ),
    );
  }
}
