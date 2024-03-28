import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/screens/homeScreen.dart';

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
    emit(LoginLoadedState(
        usernameController: usernameController,
        passwordController: passwordController,
        formKey: formKey));
    on<SignInEvent>((event, emit) {
      if (formKey.currentState!.validate()) {
        auth
            .signInWithEmailAndPassword(
                email: usernameController.text.toString(),
                password: passwordController.text.toString())
            .then((value) =>
                Navigator.of(context).pushReplacementNamed(HomeScreen.pagename))
            .onError((error, stackTrace) => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                    content: Text('Incrorrect Email Or Password'))));
      }
    });
    on<ShowLoginPasswordEvent>((event, emit) {
      if (password == false) {
        password = true;
      } else {
        password = false;
      }
      emit(LoginLoadedState(
          usernameController: usernameController,
          passwordController: passwordController,
          formKey: formKey));
    });
  }
  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
