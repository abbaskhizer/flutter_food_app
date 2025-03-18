part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLodingState extends LoginState {}


class LoginLoadedState extends LoginState {
  final TextEditingController usernameController ;
  final TextEditingController passwordController ;

  final GlobalKey<FormState> formKey ;

  LoginLoadedState({required this.usernameController, required this.passwordController, required this.formKey});
}
