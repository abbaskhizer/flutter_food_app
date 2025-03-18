part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}
@immutable
class ForgotPasswordInitialState extends ForgotPasswordState {}
@immutable
class ForgotPasswordLoadingState extends ForgotPasswordState {
  
}

@immutable
class ForgotPasswordLoadedState extends ForgotPasswordState {
  
}
@immutable
class ForgotPasswordErrorState extends ForgotPasswordState {
 final String errorMessage;
  ForgotPasswordErrorState({required this.errorMessage});
  
}