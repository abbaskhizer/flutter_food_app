
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/cart/cart_bloc.dart';
import 'package:foodie/controller/bloc/favourites/favourites_bloc.dart';
import 'package:foodie/model/foodModelClass.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const pagename = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavouritesBloc>(
      create: (context) => FavouritesBloc(context),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          elevation: 3,
          backgroundColor: Colors.red,
          title: const Text('Cart', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoadedState) {
              return StreamBuilder(
                stream: state.data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                    return GridView.builder(
                      itemCount: snapshot.data.docs.length,
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.4,
                        crossAxisCount: 1,
                      ),
                      itemBuilder: (context, index) {
                        Food cartFood = Food.fromMap(snapshot.data.docs[index].data());
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 0), // Placeholder for spacing
                                  Text(cartFood.dateTime.toString(), style: const TextStyle(color: Colors.white)),
                                  PopupMenuButton(
                                    iconColor: Colors.white,
                                    color: Colors.white,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        height: 40,
                                        onTap: () => _showDeleteDialog(cartFood.id, context),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40,
                                      child: Image.network(cartFood.imageURL),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Item name: ${cartFood.name}',
                                          style: const TextStyle(color: Colors.white, fontSize: 13),
                                        ),
                                        Text(
                                          'Item Price: ${cartFood.price}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Total Item price: ${cartFood.quentity! * cartFood.price}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Total quantity: ${cartFood.quentity}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  BlocProvider.of<CartBloc>(context).add(SendOrderEvent(cartFood: cartFood,context: context));
                                },
                                child: const Text('Send order', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load cart items'));
                  } else {
                    return const Center(child: Text('No items in the cart'));
                  }
                },
              );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(String id, BuildContext context) async {
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
              ),
            ),
            TextButton(
              onPressed: () async {
                BlocProvider.of<CartBloc>(context).add(DeleteFromCartEvent(dcumentsId: id));
              },
              child: const Text(
                'Delete Cart',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          title: const Text(
            'Do you want to Delete Cart?',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      },
    );
  }
}
