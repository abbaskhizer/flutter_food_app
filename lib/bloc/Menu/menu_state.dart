part of 'menu_bloc.dart';

@immutable
abstract class MenuState {}

class MenuInitialState extends MenuState {}

class MenuLoadingState extends MenuState {}

class MenuLoadedState extends MenuState {
  final Stream data;

  MenuLoadedState({required this.data});
}
