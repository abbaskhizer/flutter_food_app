part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}
@immutable
class SignUpButton extends SignUpEvent{}
@immutable
class ShowSignUpPasswordEvent extends SignUpEvent{}
@immutable
class ShowSignUpRetypePasswordEvent extends SignUpEvent{}
@immutable
class LoginEvent extends SignUpEvent{}
