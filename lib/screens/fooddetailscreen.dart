import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/bloc/cart/cart_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';

import 'package:foodie/riverpod/provider.dart';

import 'package:readmore/readmore.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  static const pagename = '/foodDetailScreen';
  const FoodDetailScreen({super.key});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    Food food = ModalRoute.of(context)!.settings.arguments as Food;

    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        body: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.080, top: screenHeight * 0.17),
                child: Text(
                  food.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.080),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.966, -0.9),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
                width: screenWidth,
                height: screenHeight * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: screenWidth * 0.9,
                        child: ReadMoreText(
                          food.detail.toString(),
                          trimLines: 2,
                          trimCollapsedText: '..Show more',
                          trimExpandedText: '...Show less',
                          moreStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          lessStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        )
                        // Text(
                        //   food.detail.toString(),
                        //   maxLines: 5,
                        //   style: TextStyle(fontSize: screenHeight * 0.022),
                        // ),
                        ),
                    SizedBox(
                      height: screenHeight * 0.040,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: screenHeight * 0.052,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: screenHeight * 0.050,
                            child: Image.network(food.imageURL),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: screenHeight * 0.040),
                          child: Column(
                            children: [
                              Text('Rs: ${food.price.toString()}'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      ref.read(counterProvider.notifier).decrement();
                                    },
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.020,
                                  ),
                                  Text(ref.watch(counterProvider).count.toString()),
                                  SizedBox(
                                    width: screenWidth * 0.020,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      ref.read(counterProvider.notifier).increment();
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.28,
              top: screenHeight * 0.3,
              child: Hero(
                tag: food.imageURL,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: screenHeight * 0.102,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: screenHeight * 0.1,
                    child: Image.network(food.imageURL),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: screenHeight * 0.040,
                right: screenWidth * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.050,
                    ),
                    GestureDetector(
                      onTap: () async {
                        BlocProvider.of<CartBloc>(context).add(AddToCartEvent(cartFood: food, quantity: ref.read(counterProvider).count));
                        //   var sharedprefrance =
                        //     await SharedPreferences.getInstance();
                        // var userId = sharedprefrance.getString('uuId');
                        // final cartFirestore =
                        //     FirebaseFirestore.instance.collection('user').doc(userId).collection('cart');

                        // // var cartDocumentSnapshot = await cartFirebase
                        // //     .doc(sharedprefrance.getString('userId'))
                        // //     .get();
                        // // List listOfCartProducts =
                        // //     (cartDocumentSnapshot.data()?['cart']) ?? [];
                        // // listOfCartProducts.add({
                        // //   'imageURL': food.imageURL,
                        // //   'name': food.name,
                        // //   'price': food.price,
                        // //   'quentity': ref.read(counterProvider).count,
                        // // });
                        // // cartFirebase
                        // //     .doc(sharedprefrance.getString('userId'))
                        // //     .set({'cart': listOfCartProduct s})
                        // cartFirestore.doc().set({
                        //   'imageURL': food.imageURL,
                        //   'name': food.name,
                        //   'price': food.price,
                        //   'quentity': ref.read(counterProvider).count,
                        // }).then((value) {
                        //   if (ref.read(counterProvider).count = 0) {
                        //     return ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //             content: Text('Please Select item first')));
                        //   } else {
                        //     Navigator.of(context)
                        //         .pushNamed(CartScreen.pagename);
                        //   }
                        // });
                      },
                      child: Container(
                        height: screenHeight * 0.070,
                        width: screenWidth * 0.6,
                        decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: screenWidth * 0.050),
                            Text(
                              'Add to Cart',
                              style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.020),
                            ),
                            SizedBox(
                              width: screenWidth * 0.030,
                            ),
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
