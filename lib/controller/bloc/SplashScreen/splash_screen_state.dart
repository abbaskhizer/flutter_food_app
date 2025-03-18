part of 'splash_screen_cubit.dart';

@immutable
sealed class SplashScreenState {}

@immutable
class SplashScreenInitialState extends SplashScreenState {}

@immutable
class SplashScreenLoadedState extends SplashScreenState {}
