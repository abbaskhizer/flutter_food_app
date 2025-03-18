import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/SignUp/sign_up_bloc.dart';


class SignUpScreen extends StatelessWidget {
  static const pagename = '/SignUpScreen';
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return BlocProvider(
      create: (context) => SignUpBloc(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            if (state is SignUpInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SignUpLoadedState) {
            
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.050),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
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
                              key: state.formkey,
                              child: Column(
                                children: [
                                  Material(
                                    elevation: 5,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field can\'t be empty';
                                        }
                                        RegExp regExp = RegExp(r'^[a-zA-Z]+$');
                                        if (!regExp.hasMatch(value)) {
                                          return 'Only alphabets are allowed';
                                        }
                                        return null;
                                      },
                                      controller: state.nameController,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(),
                                        hintText: 'Name',
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.040),
                                  Material(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: state.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field can\'t be empty';
                                        }
                                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
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
                                      obscureText: !BlocProvider.of<SignUpBloc>(context).password,
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: (value) {
                                        if (value != null && value.length < 8) {
                                          return 'Password must contain at least 8 characters';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(15),
                                        border: const OutlineInputBorder(),
                                        hintText: 'Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<SignUpBloc>(context).add(ShowSignUpPasswordEvent());
                                          },
                                          icon: BlocProvider.of<SignUpBloc>(context).password ? const Icon(CupertinoIcons.eye_slash) : const Icon(Icons.remove_red_eye),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.040),
                                  Material(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: state.retypePasswordController,
                                      obscureText: !BlocProvider.of<SignUpBloc>(context).reTypePassword,
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: (value) {
                                        if (value != state.passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(15),
                                        border: const OutlineInputBorder(),
                                        hintText: 'Re-Type Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<SignUpBloc>(context).add(ShowSignUpRetypePasswordEvent());
                                            
                                          },
                                          icon: BlocProvider.of<SignUpBloc>(context).reTypePassword ? const Icon(CupertinoIcons.eye_slash) : const Icon(Icons.remove_red_eye),
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
                                  BlocProvider.of<SignUpBloc>(context).add(SignUpButton());
                                },
                                child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<SignUpBloc>(context).add(LoginEvent());
                                  },
                                  child: const Text('Login', style: TextStyle(color: Colors.red)),
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
            return const Center(child: Text('Unexpected State'));
          },
        ),
      ),
    );
  }
}
