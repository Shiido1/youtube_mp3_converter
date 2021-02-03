import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  bool isloading = false;
  bool _isName = false;
  bool _isEmail = false;
  bool _isPassword = false;
  bool _isConPassword = false;

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      setState(() => _isName = true);
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

    if (_confirmPasswordController.text.isEmpty &&
            _confirmPasswordController != _passwordController ||
        !isPasswordCompliant(_confirmPasswordController.text)) {
      setState(() => _isConPassword = true);
      return false;
    }
    return true;
  }

  signUp(String name, String email, String password) async {
    Map data = {'name': name, 'email': email, 'password': password};
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response =
        await http.post('http://67.205.165.56/api/register', body: data);
    try {
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        setState(() {
          sharedPreferences.setString('token', jsonData['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Sample()),
              (Route<dynamic> route) => false);
        });
      } else {
        print(response.body);
        setState(() {
          isloading = false;
        });
        return Toast.show("Invalid detail", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      print('debug $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 65),
                Image.asset(
                  'assets/youtubelogo.png',
                ),
                SizedBox(height: 35),
                Text(
                  'CREATE AN ACCOUNT',
                  style: TextStyle(
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 65),
                Padding(
                  padding: const EdgeInsets.only(right: 35.0, left: 35.0),
                  child: TextField(
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
                      errorText: _isName ? 'Please enter your name' : null,
                    ),
                  ),
                ),
                SizedBox(height: 23),
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
                      errorText:
                          _isEmail ? 'Please enter your email address' : null,
                    ),
                  ),
                ),
                SizedBox(height: 23),
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
                      errorText: _isPassword ? 'Please enter password' : null,
                    ),
                  ),
                ),
                SizedBox(height: 23),
                Padding(
                  padding: const EdgeInsets.only(right: 35.0, left: 35.0),
                  child: TextField(
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
                  ),
                ),
                SizedBox(height: 15),
                isloading
                    ? SpinKitCircle(
                        color: AppColor.white,
                        size: 50.0,
                      )
                    : FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.redAccent,
                        onPressed: () {
                          _validateInputs();
                          signUp(_nameController.text, _emailController.text,
                              _confirmPasswordController.text);
                          setState(() {
                            isloading = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 23, left: 23),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 22,
                            ),
                          ),
                        )),
                SizedBox(height: 65),
                Text(
                  'Already have an Account?',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 35),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
