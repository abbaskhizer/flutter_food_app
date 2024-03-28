import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/notificationServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  var sharedPreferences = SharedPreferences.getInstance();

  OrderBloc(BuildContext context) : super(OrderInitialState()) {
    var orderFirestore = FirebaseFirestore.instance.collection('user');
    sharedPreferences.then((value) {
      String userId = value.getString('uuId')!;
      // ignore: invalid_use_of_visible_for_testing_member
      emit(OrderLoadedState(data: orderFirestore.doc(userId).collection('order').snapshots()));
    });

    on<DeleteFromOrderEvent>((event, emit) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('uuId'))!;
      await orderFirestore.doc(userId).collection('order').doc(event.deocumentsId).delete().whenComplete(() async {
        NotificationServices notificationServices = NotificationServices();
        notificationServices.getToken();
        notificationServices.initInfo();
        DocumentSnapshot snap = await FirebaseFirestore.instance.collection('UserTokens').doc(userId).get();
        String token = snap['token'];
        // print(token);
        notificationServices.triggerNotification(token: token, body: 'Your Order is Canceled', title: 'Dear ${sharedPreferences.getString('name')}');
      }).whenComplete(() {
        Navigator.of(context).pop();
        emit(OrderLoadedState(data: FirebaseFirestore.instance.collection('user').doc(userId).collection('order').snapshots()));
      });
    });
  }
}
