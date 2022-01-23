import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:mp3_music_converter/screens/signup/model/signup_model.dart';
import 'package:mp3_music_converter/screens/signup/provider/sign_up_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignUpProviders _signUpProvider;
  CustomProgressIndicator _progressIndicator;
  GoogleSignIn googleSign = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  String url = 'https://youtubeaudio.ca/api/google_callback_api';

  void handleGoogleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      GoogleSignInAuthentication auth = await account.authentication;

      try {
        _progressIndicator.show();
        final response = await http.post(
          url,
          body: jsonEncode({'token': auth.accessToken}),
          headers: {'Content-Type': 'application/json'},
        );
        _progressIndicator.dismiss();

        print('code is ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['message'].toString().toLowerCase().contains('success')) {
            showToast(context, message: 'Login was successful');
            preferencesHelper.saveValue(key: 'email', value: data['email']);
            preferencesHelper.saveValue(key: 'token', value: data['token']);
            preferencesHelper.saveValue(
                key: 'id', value: data['userid'].toString());
            preferencesHelper.saveValue(key: 'name', value: data['name']);

            String picUrl = data['profilepic'] == null ||
                    data['profilepic'] == ''
                ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                : data['profilepic'][0] == "/"
                    ? "https://youtubeaudio.ca" + data['profilepic']
                    : data['profilepic'];
            Provider.of<RedBackgroundProvider>(context, listen: false)
                .updateUrl(picUrl);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => MainDashBoard(),
                ),
                (route) => false);
          } else {
            showToast(context,
                message: 'Failed to login. Try again later',
                backgroundColor: Colors.white,
                textColor: Colors.black);
          }
        } else if (response.statusCode == 400) {
          Map data = jsonDecode(response.body);
          if (data['message'].toString().toLowerCase().contains('exist')) {
            showToast(context,
                message: 'User already exists. Try another login method.',
                backgroundColor: Colors.white,
                textColor: Colors.black);
          } else {
            showToast(context,
                message: 'Failed to login. Try again later',
                backgroundColor: Colors.white,
                textColor: Colors.black);
          }
        } else {
          showToast(context,
              message: 'Failed to login. Try again later',
              backgroundColor: Colors.white,
              textColor: Colors.black);
        }
      } catch (e) {
        _progressIndicator.dismiss();
        showToast(
          context,
          message: 'Operation failed',
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      }
    }
  }

  void googleSignIn() async {
    try {
      if (await googleSign.isSignedIn()) await googleSign.signOut();
      GoogleSignInAccount gresult = await googleSign.signIn();
      handleGoogleSignIn(gresult);
    } catch (e) {
      showToast(
        context,
        message: 'An error occurred. Check your internet connection.',
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      print(e);
    }
  }

  void _signUpUser() {
    FocusScope.of(context).unfocus();
    _signUpProvider.init(context);
    email = _emailController.text.trim();
    password = _passwordController.text;
    _signUpProvider.signUp(
        map: SignupModel.toJson(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _userNameController.text.trim(),
      cpassword: _confirmPasswordController.text,
    ));
    setState(() {});
  }

  @override
  void initState() {
    _signUpProvider = Provider.of<SignUpProviders>(context, listen: false);
    _signUpProvider.init(context);
    _progressIndicator = CustomProgressIndicator(context);
    print('init');
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProviders>(builder: (_, model, __) {
      return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              color: AppColor.black,
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    AppColor.black.withOpacity(0.7), BlendMode.dstATop),
                image: new AssetImage(
                  'assets/authentication.png',
                ),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: Form(
                      key: _formKey,
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
                            'CREATE AN ACCOUNT',
                            style: TextStyle(
                                color: AppColor.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 45),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return val.trim().isEmpty
                                    ? 'Please enter your name'
                                    : null;
                              },
                              controller: _nameController,
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
                                labelText: 'Name',
                                labelStyle: TextStyle(color: AppColor.white),
                                // errorText:
                                //     _isName ? 'Please enter your name' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 23),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return val.trim().isEmpty
                                    ? 'Please enter your username'
                                    : null;
                              },
                              controller: _userNameController,
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
                                labelText: 'Username',
                                labelStyle: TextStyle(color: AppColor.white),
                                // errorText: _isUsername
                                //     ? 'Please enter your username'
                                //     : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 23),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return val.trim().isEmpty
                                    ? 'Please enter your email address'
                                    : !validateEmail(val.trim())
                                        ? 'Enter a valid email address'
                                        : null;
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
                                // errorText: _isEmail
                                //     ? 'Please enter your email address'
                                //     : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 23),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return val.trim().isEmpty
                                    ? 'Password cannot be empty'
                                    : !isPasswordCompliant(val)
                                        ? 'Password must contain atleast 8 alphanumeric characters'
                                        : null;
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
                                // errorText: _isPassword
                                //     ? 'Password must contain atleast 8 alphanumeric characters'
                                //     : null,
                              ),
                              autofocus: false,
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 23),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, left: 35.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                return val.isEmpty
                                    ? 'Password cannot be empty'
                                    : val != _passwordController.text
                                        ? 'Passwords do not match'
                                        : !isPasswordCompliant(val)
                                            ? 'Password must contain atleast 8 alphanumeric characters'
                                            : null;
                              },
                              controller: _confirmPasswordController,
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
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(color: AppColor.white),
                                // errorText: _isConPassword
                                //     ? 'Passwords do not match'
                                //     : null,
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
                              TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColor.bottomRed,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate())
                                      _signUpUser();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8, right: 20, left: 20),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 25),
                          Text(
                            'Already have an Account?',
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 25),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: AppColor.bottomRed,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
      );
    });
  }
}
