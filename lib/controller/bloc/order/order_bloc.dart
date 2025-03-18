import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/notificationServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  var sharedPreferences = SharedPreferences.getInstance();
  var orderFirestore = FirebaseFirestore.instance.collection('user');
  OrderBloc(BuildContext context) : super(OrderInitialState()) {
    sharedPreferences.then((value) {
      String userId = value.getString('userId')!;
      emit(OrderLoadedState(data: orderFirestore.doc(userId).collection('order').snapshots()));
    });

   on<DeleteFromOrderEvent>((event, emit) async {
      sharedPreferences.then((value) async {
        String userId = value.getString('userId')!;
        NotificationServices notificationServices = NotificationServices();
        notificationServices.requestPermission();
        notificationServices.getToken();
        notificationServices.initInfo();
        DocumentSnapshot snap = await FirebaseFirestore.instance.collection('user').doc(userId).get();
        String token = snap['userToken'];
        // print(token);
        notificationServices.triggerNotification(token: token, body: 'Your Order is Canceled', title: 'Dear ');
        Navigator.of(context).pop();
        await FirebaseFirestore.instance.collection('user').doc(userId).collection('order').doc(event.deocumentsId).delete();
      });
    });
  }
}
