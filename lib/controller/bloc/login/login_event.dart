part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignInEvent extends LoginEvent {
  
}
@immutable
class ShowLoginPasswordEvent extends LoginEvent {

}
@immutable
class SignUpEvent extends LoginEvent {
  
}
@immutable
class ForgotPasswordEvent extends LoginEvent {
  
}
