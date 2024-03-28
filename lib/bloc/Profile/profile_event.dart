part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

@immutable
class GetImageFromGalleryEvent extends ProfileEvent {}

@immutable
class GetImageFromCamaraEvent extends ProfileEvent {}
