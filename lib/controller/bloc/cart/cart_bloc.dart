import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodie/controller/notificationServices.dart';
import 'package:http/http.dart' as http;

import 'package:foodie/model/foodModelClass.dart';
import 'package:foodie/view/screens/cartscreen.dart';
import 'package:foodie/view/screens/orderscreen.dart';

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
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 100.0,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Payment Successful!",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Your payment was completed successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, color: Colors.black54),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(OrderScreen.pagename).then((value) async {
                          //                    var sharedPreferences = await SharedPreferences.getInstance();
                          // var userId = (sharedPreferences.getString('userId'))!;

                          //                     NotificationServices notificationServices = NotificationServices();
                          //  notificationServices.requestPermission();
                          //   notificationServices.initInfo();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: const Text("Continue", style: TextStyle(fontSize: 16.0, color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
          );

          paymentIntentData = null;
        }).onError((error, stackTrace) {
          throw Exception(error.toString());
        });
      } on StripeException {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 100.0,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Payment Failed",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    "There was an issue with your payment. Please try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                    child: const Text("Try Again", style: TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
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

    Future<int> calculateTotalPrice() async {
      var sharedPreferences = await SharedPreferences.getInstance();
      String userId = sharedPreferences.getString('userId')!;

      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance.collection('user').doc(userId).collection('cart').get();

      int totalPrice = 0;

      for (var doc in cartSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int price = data['price'];
        int quantity = data['quentity'];
        totalPrice += price * quantity;
      }

      return totalPrice;
    }

    createPaymentIntent(String amount, String currency) async {
      try {
        Map<String, dynamic> body = {
          'amount': calculateAmount(amount),
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
        } else {}
      } catch (err) {
        throw Exception(err.toString());
      }
    }

    Future<void> makePayment(BuildContext c) async {
      try {
        int totalPrice = await calculateTotalPrice();
        paymentIntentData = await createPaymentIntent(totalPrice.toString(), 'PKR');

        await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                    setupIntentClientSecret: 'Your Secret Key', paymentIntentClientSecret: paymentIntentData!['client_secret'], customFlow: true, style: ThemeMode.light, merchantDisplayName: '1kay'))
            .then((value) async {
          var sharedPreferences = await SharedPreferences.getInstance();
          var userId = (sharedPreferences.getString('userId'))!;
          await displayPaymentSheet();
          NotificationServices notificationServices = NotificationServices();
          notificationServices.requestPermission();
          notificationServices.getToken();
          notificationServices.initInfo();
          DocumentSnapshot snap = await FirebaseFirestore.instance.collection('user').doc(userId).get();
          String token = snap['userToken'];
            print(token);
          notificationServices.triggerNotification(token: token, body: 'Your Order is Recived', title: 'Dear ${sharedPreferences.getString('name')}');
        });
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    var sharedPreferences = SharedPreferences.getInstance();
    var cartFirestore = FirebaseFirestore.instance.collection('user');
    sharedPreferences.then((value) {
      String userId = value.getString('userId')!;

      emit(CartLoadedState(data: FirebaseFirestore.instance.collection('user').doc(userId).collection('cart').snapshots()));
    });
    on<AddToCartEvent>((event, emit) async {
      DateTime dateTime = DateTime.now();

      if (event.quantity == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Select item first')));
      } else {
        var sharedPreferences = await SharedPreferences.getInstance();
        var userId = (sharedPreferences.getString('userId'))!;

        var cartSnapshot = await cartFirestore.doc(userId).collection('cart').where('name', isEqualTo: event.cartFood.name).get();

        if (cartSnapshot.docs.isNotEmpty) {
          var existingDoc = cartSnapshot.docs.first;
          num newQuantity = event.quantity;
          await cartFirestore.doc(userId).collection('cart').doc(existingDoc.id).update({
            'quentity': newQuantity,
          }).whenComplete(() {
            Navigator.of(context).pushNamed(CartScreen.pagename);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity updated')));
          });
        } else {
          var id = dateTime.microsecond;
          var timestamp = Timestamp.fromDate(dateTime);

          await cartFirestore.doc(userId).collection('cart').doc(id.toString()).set({
            'id': id,
            'imageURL': event.cartFood.imageURL,
            'name': event.cartFood.name,
            'price': event.cartFood.price,
            'detail': event.cartFood.detail,
            'dateTime': timestamp,
            'quentity': event.quantity
          }).whenComplete(() {
            Navigator.of(context).pushNamed(CartScreen.pagename);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added to cart')));
          });
        }
      }
    });

    on<SendOrderEvent>((event, emit) async {
      var orderFirestore = FirebaseFirestore.instance.collection('user');
      DateTime dateTime = DateTime.now();

      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('userId'))!;
      var timestamp = Timestamp.fromDate(dateTime);

      // Check if the order already exists
      var orderDoc = await orderFirestore.doc(userId).collection('order').doc(event.cartFood.id.toString()).get();
      //  var orderDocQuantity = await orderFirestore.doc(userId).collection('order').doc(event.cartFood.quentity.toString()).get();

      if (orderDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This item has already been ordered.')),
        );
        return;
      }

      await orderFirestore.doc(userId).collection('order').doc(event.cartFood.id.toString()).set({
        'id': event.cartFood.id,
        'imageURL': event.cartFood.imageURL,
        'name': event.cartFood.name,
        'price': event.cartFood.price,
        'detail': event.cartFood.detail,
        'dateTime': timestamp,
        'quentity': event.cartFood.quentity,
      }).whenComplete(() async {
        await makePayment(context);
        // .then((value)async {
        //    NotificationServices notificationServices = NotificationServices();
        //    notificationServices.requestPermission();
        //    notificationServices.initInfo();
        //    notificationServices.getToken();
        //    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('user').doc(userId).get();
        //   String token = snap['token'];
        //    print('Token fetched successfully: $token');
        //    notificationServices.triggerNotification(token: token, body: 'Your Order is Recived', title: 'Dear ${sharedPreferences.getString('name')}');
        // },);
      });
    });

    on<DeleteFromCartEvent>((event, emit) async {
      sharedPreferences.then((value) async {
        String userId = value.getString('userId')!;
        Navigator.of(context).pop();
        await FirebaseFirestore.instance.collection('user').doc(userId).collection('cart').doc(event.dcumentsId).delete();
      });
    });
  }
}
