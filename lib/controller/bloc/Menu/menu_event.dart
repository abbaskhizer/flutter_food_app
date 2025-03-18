// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_bloc.dart';

@immutable
abstract class MenuEvent {}
@immutable
class FavoritesMenuEvent extends MenuEvent {
  final Food menuFood;
  final String id;

  FavoritesMenuEvent({required this.menuFood,required this.id});
}



