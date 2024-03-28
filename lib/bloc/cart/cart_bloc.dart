import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:foodie/modelClass/foodModelClass.dart';
import 'package:foodie/notificationServices.dart';
import 'package:foodie/screens/cartscreen.dart';
import 'package:foodie/screens/orderscreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(BuildContext context) : super(CartInitialState()) {
    Map<String, dynamic>? paymentIntentData;
    displayPaymentSheet() async {
      try {
        await Stripe.instance.presentPaymentSheet().then((newValue) {
          showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                    backgroundColor: Colors.red,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 100.0,
                        ),
                        SizedBox(height: 10.0),
                        Text(style: TextStyle(color: Colors.black), "Payment Successful!"),
                      ],
                    ),
                  ));

          paymentIntentData = null;
        }).onError((error, stackTrace) {
          throw Exception(error.toString());
          //    print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        });
      } on StripeException {
        const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
            ],
          ),
        );
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    calculateAmount(String amount) {
      final a = (int.parse(amount)) * 100;
      return a.toString();
    }

    createPaymentIntent(String amount, String currency) async {
      try {
        Map<String, dynamic> body = {
          'amount': calculateAmount('20'),
          'currency': currency,
          'payment_method_types[]': 'card',
        };
        //   print(body);
        var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body, headers: {
          'Authorization': 'Bearer sk_test_51NSeUcBFkokQNkwsWWRtrPT591oZcbG4vKNeZkPgeJURwBWgo9XyWma4uds32TXUlptEWrZFNNmKHrxFKOHduL7N00R9gXv9ph',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          // print(response.statusCode);
        }
        //  print('Create Intent reponse ===> ${response.body.toString()}');
      } catch (err) {
        throw Exception(err.toString());
      }
    }

    Future<void> makePayment(BuildContext c) async {
      try {
        paymentIntentData = await createPaymentIntent('100', 'USD'); //json.decode(response.body);
        // print('Response body==>${response.body.toString()}');
        await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                    setupIntentClientSecret: 'Your Secret Key',
                    paymentIntentClientSecret: paymentIntentData!['client_secret'],
                    //applePay: PaymentSheetApplePay.,
                    //googlePay: true,
                    //testEnv: true,
                    customFlow: true,
                    style: ThemeMode.light,
                    // merchantCountryCode: 'US',
                    merchantDisplayName: '1kay'))
            .then((value) async {
          var sharedPreferences = await SharedPreferences.getInstance();
          var userId = (sharedPreferences.getString('uuId'))!;

          await displayPaymentSheet();
          // ignore: use_build_context_synchronously
         
          NotificationServices notificationServices = NotificationServices();
          notificationServices.requestPermission();
          notificationServices.getToken();
          notificationServices.initInfo();
          DocumentSnapshot snap = await FirebaseFirestore.instance.collection('UserTokens').doc(userId).get();
          String token = snap['token'];
          //  print(token);
          notificationServices.triggerNotification(token: token, body: 'Your Order is Recived', title: 'Dear ${sharedPreferences.getString('name')}');
        }).whenComplete(() =>  Navigator.of(context).pushNamed(OrderScreen.pagename));

        ///now finally display payment sheeet
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    //  Future<Map<String, dynamic>>

    var sharedPreferences = SharedPreferences.getInstance();
    var cartFirestore = FirebaseFirestore.instance.collection('user');
    sharedPreferences.then((value) {
      String userId = value.getString('uuId')!;
      // ignore: invalid_use_of_visible_for_testing_member
      emit(CartLoadedState(data: FirebaseFirestore.instance.collection('user').doc(userId).collection('cart').snapshots()));
    });
    on<AddToCartEvent>((event, emit) async {
      DateTime dateTime = DateTime.now();
      if (event.quantity == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Select item first')));
      } else {
        var id = dateTime.microsecond;
        var sharedPreferences = await SharedPreferences.getInstance();
        var userId = (sharedPreferences.getString('uuId'))!;

        await cartFirestore.doc(userId).collection('cart').doc(id.toString()).set({
          'id': id,
          'imageURL': event.cartFood.imageURL,
          'name': event.cartFood.name,
          'price': event.cartFood.price,
          'detail': event.cartFood.detail,
          'dateTime': dateTime.day / dateTime.month / dateTime.year,
          'quentity': event.quantity
        }).whenComplete(() {
          Navigator.of(context).pushNamed(CartScreen.pagename);
        });
      }
    });

    on<SendOrderEvent>((event, emit) async {
      var orderFirestore = FirebaseFirestore.instance.collection('user');
      DateTime dateTime = DateTime.now();

      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('uuId'))!;

      await orderFirestore.doc(userId).collection('order').doc(event.cartFood.id.toString()).set({
        'id': event.cartFood.id,
        'imageURL': event.cartFood.imageURL,
        'name': event.cartFood.name,
        'price': event.cartFood.price,
        'detail': event.cartFood.detail,
        'dateTime': dateTime.microsecondsSinceEpoch,
        'quentity': event.cartFood.quentity,
      }).whenComplete(() async {
        await makePayment(context).whenComplete(() async {});
      });
    });
    on<DeleteFromCartEvent>((event, emit) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('uuId'))!;
      await cartFirestore.doc(userId).collection('cart').doc(event.dcumentsId).delete().whenComplete(() {
        Navigator.of(context).pop();
        emit(CartLoadedState(data: FirebaseFirestore.instance.collection('user').doc(userId).collection('cart').snapshots()));
      });
    });
  }
}
