// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}
@immutable
class FavoritesHomeEvent extends HomeEvent{
  final Food homeFood;
  final String id;

  FavoritesHomeEvent({required this.homeFood,required this.id});
}
@immutable
class GotoFoodDetailEvent extends HomeEvent {
 


}
