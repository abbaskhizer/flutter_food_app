part of 'home_bloc.dart';

@immutable
abstract class HomeState {}
@immutable
class HomeInitialState extends HomeState {}

@immutable
class HomeLoadingState extends HomeState {}

@immutable
class HomeLoadedState extends HomeState {
  final Stream data;

  HomeLoadedState({required this.data});
}


