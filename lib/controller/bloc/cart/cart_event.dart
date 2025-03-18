part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

@immutable
class AddToCartEvent extends CartEvent {
  final Food cartFood;
  final int quantity;

  AddToCartEvent({required this.cartFood, required this.quantity});
}

@immutable
class DeleteFromCartEvent extends CartEvent {
  final String dcumentsId;

  DeleteFromCartEvent({required this.dcumentsId});
}

@immutable
class SendOrderEvent extends CartEvent {
  final Food cartFood;
  final BuildContext context;

  SendOrderEvent({required this.cartFood, required this.context});

}
