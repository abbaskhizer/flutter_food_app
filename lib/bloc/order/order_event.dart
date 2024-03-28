part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

@immutable
class DeleteFromOrderEvent extends OrderEvent {
  final String deocumentsId;

  DeleteFromOrderEvent({required this.deocumentsId});

}
