import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:mp3_music_converter/screens/signup/model/signup_model.dart';
import 'package:mp3_music_converter/screens/signup/provider/sign_up_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
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

  bool isloading = false;
  bool _isName = false;
  bool _isEmail = false;
  bool _isPassword = false;
  bool _isConPassword = false;
  bool _isUsername = false;
  SignUpProviders _signUpProvider;

  void googleSignIn() async {
    GoogleSignIn googleSign = GoogleSignIn(scopes: ['email', 'profile']);
    String url = 'https://youtubeaudio.com/api/google_callback_api';

    try {
      final gresult = await googleSign.signIn();
      final auth = await gresult.authentication;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {'token': auth.idToken},
        ),
      );

      print(auth.idToken);
      print(auth.accessToken);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
      } else {
        print(response.statusCode);
        final data = jsonDecode(jsonEncode(response.body));
        print(data);
        showToast(context,
            message: 'Failed to login. Please try another method.');
      }
    } catch (e) {
      showToast(context,
          message: 'Failed to login. Check your internet connection');
      print(e);
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      setState(() => _isName = true);
      return false;
    }

    if (_userNameController.text.isEmpty) {
      setState(() {
        _isUsername = true;
      });
      return false;
    }

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

    if (_confirmPasswordController.text.isEmpty ||
        _confirmPasswordController.text != _passwordController.text) {
      setState(() => _isConPassword = true);
      return false;
    }
    return true;
  }

  void _signUpUser() {
    FocusScope.of(context).unfocus();

    if (!_validateInputs()) return;

    email = _emailController.text.trim();
    password = _passwordController.text;
    _signUpProvider.signUp(
        map: SignupModel.toJson(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _userNameController.text.trim(),
    ));
    setState(() {});
  }

  @override
  void initState() {
    _signUpProvider = Provider.of<SignUpProviders>(context, listen: false);
    _signUpProvider.init(context);
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
                          child: TextField(
                            onChanged: (val) {
                              if (val.isNotEmpty)
                                setState(() {
                                  _isName = false;
                                });
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
                              errorText:
                                  _isName ? 'Please enter your name' : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 23),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 35.0, left: 35.0),
                          child: TextField(
                            onChanged: (val) {
                              if (val.isNotEmpty)
                                setState(() {
                                  _isUsername = false;
                                });
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
                              errorText: _isUsername
                                  ? 'Please enter your username'
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 23),
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
                                  ? 'Please enter your email address'
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 23),
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
                              errorText:
                                  _isPassword ? 'Please enter password' : null,
                            ),
                            autofocus: false,
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 23),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 35.0, left: 35.0),
                          child: TextField(
                            onChanged: (val) {
                              if (val.isNotEmpty)
                                setState(() {
                                  _isConPassword = false;
                                });
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
                              errorText: _isConPassword
                                  ? 'Please enter correct password'
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
                            TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColor.bottomRed,
                                ),
                                onPressed: () {
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
                );
              },
            )),
      );
    });
  }
}
