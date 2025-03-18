
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foodie/view/screens/forgotpassword.dart';
import 'package:foodie/view/screens/homeScreen.dart';
import 'package:foodie/view/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool password = false;

  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  LoginBloc(BuildContext context) : super(LoginInitialState()) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(LoginLoadedState(usernameController: usernameController, passwordController: passwordController, formKey: formKey));

   on<SignInEvent>((event, emit) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var userId=sharedPreferences.getString('userId');
  if (formKey.currentState!.validate() && userId!= null){
    auth
        .signInWithEmailAndPassword(
          email: usernameController.text.toString(),
          password: passwordController.text.toString(),
        )
        .then((value)async {
      await FirebaseFirestore.instance
      .collection('user')
      .doc(userId)
      .collection('cart')
      .get();

       await FirebaseFirestore.instance
      .collection('user')
      .doc(userId)
      .collection('order')
      .get();

       await FirebaseFirestore.instance
      .collection('user')
      .doc(userId)
      .collection('favorite')
      .get();

          Navigator.of(context).pushReplacementNamed(HomeScreen.pagename);
        })
        .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect Email Or Password')),
          );
        });
  }
});

  
    on<ShowLoginPasswordEvent>((event, emit) {
      if (password == false) {
        password = true;
      } else {
        password = false;
      }
      emit(LoginLoadedState(usernameController: usernameController, passwordController: passwordController, formKey: formKey));
    });
    on<SignUpEvent>((event, emit) => Navigator.of(context).pushNamed(SignUpScreen.pagename) );
    on<ForgotPasswordEvent>((event, emit) => Navigator.of(context).pushNamed(ForgotPasswordScreen.pagename) );
  }
  


  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
