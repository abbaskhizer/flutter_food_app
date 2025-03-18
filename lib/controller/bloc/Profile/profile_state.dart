part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

@immutable
class ProfileInitialState extends ProfileState {}
@immutable
class ProfileLoadingState extends ProfileState {}


@immutable
class ProfileLoadedState extends ProfileState {
  final String? imageURL;
  final String nameValue;
  final String emailValue;

  ProfileLoadedState({required this.imageURL, required this.nameValue, required this.emailValue});
}

@immutable
class ProfileErrorState extends ProfileState {
  final String errorMessage;

  ProfileErrorState({required this.errorMessage});
}
