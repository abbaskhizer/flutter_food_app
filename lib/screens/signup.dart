import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/SignUp/sign_up_bloc.dart';

import 'package:foodie/screens/login.dart';

class SignUpScreen extends StatelessWidget {
  static const pagename = '/SignUpScreen';
  const SignUpScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    return BlocProvider(
      create: (context) => SignUpBloc(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case SignUpInitialState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                (state as SignUpLoadedState);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.050),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Form(
                                      key: state.formkey,
                                      child: Column(
                                        children: [
                                          Material(
                                            elevation: 5,
                                            child: TextFormField(
                                                controller:
                                                    state.nameController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(15),
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: 'Name',
                                                        prefixIcon: Icon(
                                                            Icons.person))),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.040,
                                          ),
                                          Material(
                                            elevation: 5,
                                            child: TextFormField(
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This Field can\'t be empty ';
                                                  } else if ((!(RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(value)))) {
                                                    return 'Please enter correct email';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller:
                                                    state.emailController,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Email',
                                                  prefixIcon: Icon(
                                                    Icons.mail,
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.040,
                                          ),
                                          Material(
                                            elevation: 5,
                                            child: TextFormField(
                                                keyboardType: TextInputType
                                                    .number,
                                                obscureText: !BlocProvider.of<
                                                        SignUpBloc>(context)
                                                    .password,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                validator: (value) {
                                                  if (value!.length < 7) {
                                                    return 'Password Must Contain 8 Characters';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller:
                                                    state.passwordController,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    hintText: 'Password',
                                                    prefixIcon:
                                                        const Icon(Icons.lock),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      SignUpBloc>(
                                                                  context)
                                                              .add(
                                                                  ShowSignUpPasswordEvent());
                                                        },
                                                        icon: BlocProvider.of<
                                                                        SignUpBloc>(
                                                                    context)
                                                                .password
                                                            ? const Icon(Icons
                                                                .remove_red_eye)
                                                            : const Icon(
                                                                CupertinoIcons
                                                                    .eye_slash)))),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.040,
                                          ),
                                          Material(
                                            elevation: 5,
                                            child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                obscureText: !BlocProvider.of<
                                                        SignUpBloc>(context)
                                                    .reTypePassword,
                                                validator: (value) {
                                                  if (!(value!.contains(state
                                                      .passwordController
                                                      .text))) {
                                                    return 'Password not match';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller: state
                                                    .retypePasswordController,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    hintText:
                                                        'Re-Type Password',
                                                    prefixIcon:
                                                        const Icon(Icons.lock),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      SignUpBloc>(
                                                                  context)
                                                              .add(
                                                                  ShowSignUpRetypePasswordEvent());
                                                        },
                                                        icon: BlocProvider.of<
                                                                        SignUpBloc>(
                                                                    context)
                                                                .reTypePassword
                                                            ? const Icon(Icons
                                                                .remove_red_eye)
                                                            : const Icon(
                                                                CupertinoIcons
                                                                    .eye_slash)))),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.6,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      elevation: 10,
                                      shadowColor: Colors.black),
                                  onPressed: () {
                                    BlocProvider.of<SignUpBloc>(context)
                                        .add(SignUpButton());
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already Have An Account?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              LoginScreen.pagename);
                                    },
                                    child: const Text(
                                      'Login',
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
