
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/Forgotpassword/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const pagename = '/forgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController forgotPasswordController = TextEditingController();

  @override
  void dispose() {
    forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    final auth=FirebaseAuth.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.040),
                ),
                Text(
                  'Please enter your email',
                  style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.020),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: screenHeight * 0.60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: screenHeight * 0.010),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: forgotPasswordController,
                              decoration: const InputDecoration(
                                focusColor: Colors.amber,
                                contentPadding: EdgeInsets.all(15),
                                border: OutlineInputBorder(),
                                hintText: 'Enter Your Email',
                                prefixIcon: Icon(Icons.mail),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.040),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 10,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () {
                          final email = forgotPasswordController.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter your email')),
                            );
                          } else {
                           auth.sendPasswordResetEmail(email: email);
                          }
                        },
                        child: const Text(
                          'Send OTP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
