import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ForgotPasswordScreen extends StatefulWidget {
  static const pagename='/forgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgotPasswordController = TextEditingController();

  //final _formKey = GlobalKey<FormState>();

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

    final auth = FirebaseAuth.instance;

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
                  style: TextStyle(
                      color: Colors.white, fontSize: screenHeight * 0.040),
                ),
                Text(
                  'Please enter your email',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenHeight * 0.020),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
            height: screenHeight * 0.60,
              decoration:const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: screenHeight * 0.010,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Material(
                              elevation: 10,
                              shadowColor: Colors.black,
                              child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Email';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: forgotPasswordController,
                                  decoration:const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Your Email',
                                      prefixIcon: Icon(Icons.mail))),
                            ),
                            SizedBox(
                              height: screenHeight * 0.040,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 10,
                            shadowColor: Colors.black),
                        onPressed: () {
                          auth
                              .sendPasswordResetEmail(
                                  email:
                                      forgotPasswordController.text.toString())
                              .then((value) {
                                
                                return ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'We send you a massage on email to recover a passsword')));
                              })
                              .onError((error, stackTrace) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(error.toString()))));
                        },
                        child:const Text(
                          'Send OTP',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
