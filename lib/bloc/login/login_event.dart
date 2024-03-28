part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignInEvent extends LoginEvent {
  
}

class ShowLoginPasswordEvent extends LoginEvent {
  
}
