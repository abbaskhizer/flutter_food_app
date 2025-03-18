// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

@immutable
class GetImageFromGalleryEvent extends ProfileEvent {}

@immutable
class GetImageFromCamaraEvent extends ProfileEvent {}

@immutable
class LogoutEvent extends ProfileEvent {}

@immutable
class LogOutDialogEvent extends ProfileEvent {

}
@immutable
class CancelDialogEvent extends ProfileEvent {

}
@immutable
class AboutEvent extends ProfileEvent {}
@immutable
class MyOrderEvent extends ProfileEvent {}
@immutable
class ResetPasswordtEvent extends ProfileEvent {}
