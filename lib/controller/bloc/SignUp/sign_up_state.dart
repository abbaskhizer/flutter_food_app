// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

@immutable
class SignUpInitialState extends SignUpState {}

@immutable
class SignUpLoadingState extends SignUpState {}

@immutable
class SignUpLoadedState extends SignUpState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController retypePasswordController;
  final GlobalKey<FormState> formkey;

  SignUpLoadedState(
      {required this.emailController,
      required this.passwordController,
      required this.nameController,
      required this.retypePasswordController,
      required this.formkey});
}
@immutable
class SignUpErrorState extends SignUpState {
 final String masage;
  SignUpErrorState({
    required this.masage,
  });
}

