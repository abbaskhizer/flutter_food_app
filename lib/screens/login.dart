import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/login/login_bloc.dart';
import 'package:foodie/screens/forgotpassword.dart';

import 'package:foodie/screens/signup.dart';

class LoginScreen extends StatelessWidget {
  static const pagename = '/loginScreen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;

    return BlocProvider(
      create: (context) => LoginBloc(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case LoginInitialState:
                return const Center(child: CircularProgressIndicator());
              default:
                (state as LoginLoadedState);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.040),
                          ),
                          Text(
                            'Please Sign in to Continue',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.020),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: screenHeight * 0.010,
                            ),
                            Form(
                                key: state.formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.1),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Material(
                                            elevation: 5,
                                            //shadowColor: Colors.black,
                                            child: TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter Email';
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                controller:
                                                    state.usernameController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(15),
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Email',
                                                        prefixIcon:
                                                            Icon(Icons.mail))),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.040,
                                          ),
                                          Material(
                                            elevation: 5,
                                            //shadowColor: Colors.black,
                                            child: TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter Password';
                                                  }
                                                  return null;
                                                },
                                                keyboardType: TextInputType
                                                    .number,
                                                obscureText: !BlocProvider.of<
                                                        LoginBloc>(context)
                                                    .password,
                                                controller:
                                                    state.passwordController,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    hintText: 'Password',
                                                    prefixIcon: const Icon(
                                                      Icons.lock,
                                                    ),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      LoginBloc>(
                                                                  context)
                                                              .add(
                                                                  ShowLoginPasswordEvent());
                                                        },
                                                        icon: BlocProvider.of<
                                                                        LoginBloc>(
                                                                    context)
                                                                .password
                                                            ? const Icon(Icons
                                                                .remove_red_eye)
                                                            : const Icon(
                                                                CupertinoIcons
                                                                    .eye_slash)))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: screenWidth * 0.6,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      elevation: 10,
                                      shadowColor: Colors.black),
                                  onPressed: () {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(SignInEvent());
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      ForgotPasswordScreen.pagename);
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.050),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don"t Have Account?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              SignUpScreen.pagename);
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
