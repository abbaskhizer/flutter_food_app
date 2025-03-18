import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/view/screens/homeScreen.dart';
import 'package:foodie/view/screens/login.dart';
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
    emit(SignUpLoadedState(
        formkey: formkey, emailController: emailController, passwordController: passwordController, nameController: nameController, retypePasswordController: retypePasswordController));

    on<SignUpButton>((event, emit) async {
      if (formkey.currentState!.validate()) {
        // emit(SignUpLoadingState());
        try {
          UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());

          String userId = userCredential.user!.uid;

          await userfirestore
              .doc(userId)
              .set({'name': nameController.text, 'email': emailController.text, 'password': passwordController.text, 'retypePassword': retypePasswordController.text})
              .whenComplete(() async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('userId', userId);
                await prefs.setString('name', nameController.text.trim());
                await prefs.setString('email', emailController.text.trim());
               
              }).then((value) =>  Navigator.of(context).pushReplacementNamed(HomeScreen.pagename),)
              .then(
                (value) => SignUpLoadedState(
                    emailController: emailController, passwordController: passwordController, nameController: nameController, retypePasswordController: retypePasswordController, formkey: formkey),
              );
             
        } catch (e) {
          emit(SignUpErrorState(masage: e.toString()));
        }
      }
    });

    on<ShowSignUpPasswordEvent>((event, emit) {
      if (password == false) {
        password = true;
      } else {
        password = false;
      }
      emit(SignUpLoadedState(
          formkey: formkey, emailController: emailController, passwordController: passwordController, nameController: nameController, retypePasswordController: retypePasswordController));
    });
    on<ShowSignUpRetypePasswordEvent>((event, emit) {
      if (reTypePassword == false) {
        reTypePassword = true;
      } else {
        reTypePassword = false;
      }
      emit(SignUpLoadedState(
          formkey: formkey, emailController: emailController, passwordController: passwordController, nameController: nameController, retypePasswordController: retypePasswordController));
    });
    on<LoginEvent>((event, emit) => Navigator.of(context).pushNamed(LoginScreen.pagename));
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
