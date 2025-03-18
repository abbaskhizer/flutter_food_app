part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

@immutable
final class CartInitialState extends CartState {}

@immutable
final class CartLoadingState extends CartState {}


@immutable
final class CartLoadedState extends CartState {
  final Stream  data;

  CartLoadedState({required this.data});
}


@immutable
final class CartErrorState extends CartState {
  final String message;

  CartErrorState({required this.message});
}
