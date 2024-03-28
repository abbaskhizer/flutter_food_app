import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final userfirestore = FirebaseFirestore.instance.collection('user');

  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool password = false;
  bool reTypePassword = false;
  SignUpBloc(BuildContext context) : super(SignUpInitialState()) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SignUpLoadedState(
        formkey: formkey,
        emailController: emailController,
        passwordController: passwordController,
        nameController: nameController,
        retypePasswordController: retypePasswordController));
    on<SignUpButton>((event, emit) {
      if (formkey.currentState!.validate()) {
        auth
            .createUserWithEmailAndPassword(
                email: emailController.text.toString(),
                password: passwordController.text.toString())
            .then((userCredential) async {
          var sharedprefrance = await SharedPreferences.getInstance();
          var userId = sharedprefrance.getString('uuId');

          userfirestore.doc(userId).set({
            'userId': userId,
            'name': nameController.text.toString(),
            'email': emailController.text.toString(),
            'password': passwordController.text.toString(),
            'retypePassword': retypePasswordController.text.toString()
          });
        }).then((value) async {
          var sharedprefrance = await SharedPreferences.getInstance();
          sharedprefrance.setString('name', nameController.text.toString());
          sharedprefrance.setString('email', emailController.text.toString());
        }).then((value) => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.pagename));
      }
    });
    on<ShowSignUpPasswordEvent>((event, emit) {
      if (password == false) {
        password = true;
      } else {
        password = false;
      }
       emit(SignUpLoadedState(
        formkey: formkey,
        emailController: emailController,
        passwordController: passwordController,
        nameController: nameController,
        retypePasswordController: retypePasswordController));

    });
    on<ShowSignUpRetypePasswordEvent>((event, emit) {
      if (reTypePassword == false) {
        reTypePassword = true;
      } else {
        reTypePassword = false;
      }
        emit(SignUpLoadedState(
        formkey: formkey,
        emailController: emailController,
        passwordController: passwordController,
        nameController: nameController,
        retypePasswordController: retypePasswordController));
    });
  }
  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    return super.close();
  }
}
