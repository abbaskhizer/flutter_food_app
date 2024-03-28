part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesState {}

@immutable
final class FavouritesInitialState extends FavouritesState {}

@immutable
final class FavouritesLoadingState extends FavouritesState {}

@immutable
final class FavouritesLoadedState extends FavouritesState {
  final Stream data;

  FavouritesLoadedState({required this.data});
}
