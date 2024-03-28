part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent {}

@immutable
class FavouritesDeleteEvent extends FavouritesEvent {
  final String documentId;

  FavouritesDeleteEvent({required this.documentId});
}


