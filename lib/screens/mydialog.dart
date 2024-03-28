  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/cart/cart_bloc.dart';
import 'package:foodie/bloc/favourites/favourites_bloc.dart';
import 'package:foodie/bloc/order/order_bloc.dart';

Future<void> showMyCartDialog(String id, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.red,
          elevation: 3,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () async {
                  BlocProvider.of<CartBloc>(context)
                      .add(DeleteFromCartEvent(dcumentsId: id));
                
                },
                child: const Text(
                  'Delete Cart',
                  style: TextStyle(color: Colors.white),
                ))
          ],
          title: const Text('Do you want to Delete Cart?',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        );
      },
    );
  }
  Future<void> showMyFavoritesDialog(String id, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.red,
          elevation: 3,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () async {
                  BlocProvider.of<FavouritesBloc>(context).add(FavouritesDeleteEvent(documentId:id ));
                
                
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.white),
                ))
          ],
          title: const Text('Do you want to remove From Favorites?',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        );
      },
    );
  }

  Future<void> showMyOrderDialog(String id, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.red,
          elevation: 3,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () async {
                     BlocProvider.of<OrderBloc>(context).add(DeleteFromOrderEvent(deocumentsId: id));
                
                  // var sharedprefrance = await SharedPreferences.getInstance();
                  // final List listOfCart = await FirebaseFirestore.instance
                  //     .collection('cart')
                  //     .doc(sharedprefrance.getString('userId'))
                  //     .get()
                  //     .then((value) => value.data()!['cart']);
                  // listOfCart.removeAt(index);
                  // await FirebaseFirestore.instance
                  //     .collection('cart')
                  //     .doc(sharedprefrance.getString('userId'))
                  //     .update({'cart': listOfCart}).whenComplete(
                  //         () => Navigator.of(context).pop());
                  // firebaseFirestore

                  //     .delete()
                  //     .then((value) => Navigator.of(context).pop());
                },
                child: const Text(
                  'Cancel Order',
                  style: TextStyle(color: Colors.white),
                ))
          ],
          title: const Text('Do you want to Cancel Order?',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        );
      },
    );
  }