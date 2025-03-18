part of 'latest_bloc.dart';

@immutable
abstract class LatestEvent {}

@immutable
class FavoritesLatestEvent extends LatestEvent{
  final Food latestFood;
  final String id;

  FavoritesLatestEvent({required this.latestFood,required this.id});
}
@immutable
class GotoFoodDetailEvent extends LatestEvent{
 
}

