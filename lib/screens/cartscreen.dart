import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/cart/cart_bloc.dart';
import 'package:foodie/bloc/favourites/favourites_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';



import 'package:foodie/screens/mydialog.dart';

class CartScreen extends StatelessWidget {
 const CartScreen({super.key});
  static const pagename = '/cartScreen';



  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    var clintHeight = screenHeight - kToolbarHeight;

    return BlocProvider<FavouritesBloc>(create: (context) => FavouritesBloc(context),
      child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Colors.white),
            elevation: 3,
            backgroundColor: Colors.red,
            title: const Text(
              'Cart',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            switch (state.runtimeType) {
              case CartInitialState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                (state as CartLoadedState);
                return Center(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: StreamBuilder(
                            stream: state.data,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.connectionState ==
                                      ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return GridView.builder(
                                  itemCount:
                                      // snapshot.data!.data()!['cart'].length,
                                      snapshot.data!.docs.length,
                                  padding: const EdgeInsets.all(12),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 1.4,
                                          crossAxisCount: 1),
                                  itemBuilder: (context, index) {
                                    // Food cartFood = Food.fromMap(
                                    //    snapshot.data!.data()!['cart'][index]);
                                    Food cartFood = Food.fromMap(
                                        snapshot.data!.docs[index].data());
                                    return Container(
                                      height: clintHeight * 0.1,
                                      width: screenWidth * 0.9,
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.000005,
                                              ),
                                              Text(
                                                cartFood.dateTime.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              PopupMenuButton(iconColor: Colors.white,
                                                color: Colors.white,
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      height: clintHeight * 0.040,
                                                      onTap: () {
                                                        showMyCartDialog(
                                                            cartFood.id, context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.delete),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.040,
                                                          ),
                                                          const Text('Delete'),
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: clintHeight * 0.030,
                                          ),
                                          SingleChildScrollView(scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: screenWidth * 0.15,
                                                  child: Image.network(
                                                      cartFood.imageURL),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Item name:${cartFood.name}',
                                                      style: const TextStyle(
                                                          color: Colors.white,fontSize:13 ),
                                                    ),
                                                    Text(
                                                      'Item Price:${cartFood.price}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      'Total Item price:${(cartFood.price * cartFood.quentity!)}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      'Total Item :${cartFood.quentity}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 3,
                                                  backgroundColor: Colors.white),
                                              onPressed: () async {
                                                BlocProvider.of<CartBloc>(
                                                        context)
                                                    .add(SendOrderEvent(
                                                  cartFood: cartFood,
                                                  context: context
                                                ));
                                               
                                              },
                                              child: const Text(
                                                'Send order',
                                                style:
                                                    TextStyle(color: Colors.red),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Text('SomeThing Went Wrong');
                              }
                            },
                          )),
                    ],
                  ),
                );
            }
          })),
    );
  }
}
