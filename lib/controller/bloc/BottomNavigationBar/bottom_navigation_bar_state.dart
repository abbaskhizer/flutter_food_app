part of 'bottom_navigation_bar_bloc.dart';

@immutable
abstract class BottomNavigationBarState {
 const BottomNavigationBarState({required this.tabIndex});
  final int tabIndex;
}

@immutable
class BottomNavigationBarInitialState extends BottomNavigationBarState {
 const BottomNavigationBarInitialState({required super.tabIndex});
}


