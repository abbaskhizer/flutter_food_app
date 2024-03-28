part of 'order_bloc.dart';

@immutable
abstract class OrderState {}
@immutable
class OrderInitialState extends OrderState {}

@immutable
class OrderLoadingState extends OrderState {}


@immutable
class OrderLoadedState extends OrderState {
  final Stream data;

  OrderLoadedState({required this.data});
}
