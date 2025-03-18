part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

@immutable
class ForgotPasswordButton extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordButton({required this.email});
  
}


