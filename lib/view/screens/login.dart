
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/login/login_bloc.dart';
import 'package:foodie/view/screens/forgotpassword.dart';

class LoginScreen extends StatelessWidget {
  static const pagename = '/loginScreen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return BlocProvider(
      create: (context) => LoginBloc(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoginLoadedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.040),
                        ),
                        Text(
                          'Please Sign in to Continue',
                          style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.020),
                        ),
                      ],
                    ),
                  ),

                  // Form Container
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Form(
                              key: state.formKey,
                              child: Column(
                                children: [
                                  Material(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: state.usernameController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) => value?.isEmpty == true ? 'Enter Email' : null,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(),
                                        hintText: 'Email',
                                        prefixIcon: Icon(Icons.mail),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.040),
                                  Material(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: state.passwordController,
                                      obscureText: !BlocProvider.of<LoginBloc>(context).password,
                                      validator: (value) => value?.isEmpty == true ? 'Enter Password' : null,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(15),
                                        border: const OutlineInputBorder(),
                                        hintText: 'Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<LoginBloc>(context).add(ShowLoginPasswordEvent());
                                          },
                                          icon: BlocProvider.of<LoginBloc>(context).password
                                              ? const Icon(CupertinoIcons.eye_slash)
                                              : const Icon(Icons.remove_red_eye),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                  BlocProvider.of<LoginBloc>(context).add(SignInEvent());
                                },
                                child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(ForgotPasswordScreen.pagename);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't Have an Account?"),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<LoginBloc>(context).add(SignUpEvent());
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('Unexpected state'));
          },
        ),
      ),
    );
  }
}
