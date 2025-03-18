
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/controller/bloc/cart/cart_bloc.dart';
import 'package:foodie/model/foodModelClass.dart';
import 'package:foodie/controller/riverpod/provider.dart';
import 'package:readmore/readmore.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  static const pagename = '/foodDetailScreen';
  const FoodDetailScreen({super.key});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Food food = ModalRoute.of(context)!.settings.arguments as Food;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width * 0.08,
                top: screenSize.height * 0.17,
              ),
              child: Text(
                food.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.08,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.966, -0.9),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              width: screenSize.width,
              height: screenSize.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenSize.width * 0.9,
                    child: ReadMoreText(
                      food.detail.toString(),
                      trimLines: 2,
                      trimCollapsedText: '..Show more',
                      trimExpandedText: '...Show less',
                      moreStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      lessStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: screenSize.height * 0.052,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: screenSize.height * 0.05,
                          child: Image.network(food.imageURL),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.height * 0.04),
                        child: Column(
                          children: [
                            Text('Rs: ${food.price}'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => ref.read(counterProvider.notifier).decrement(),
                                ),
                                SizedBox(width: screenSize.width * 0.02),
                                Text(ref.watch(counterProvider).count.toString()),
                                SizedBox(width: screenSize.width * 0.02),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => ref.read(counterProvider.notifier).increment(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: screenSize.width * 0.28,
            top: screenSize.height * 0.3,
            child: Hero(
              tag: 'image',
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: screenSize.height * 0.102,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: screenSize.height * 0.1,
                  child: Image.network(food.imageURL),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.04,
            right: screenSize.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: screenSize.width * 0.05),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<CartBloc>(context).add(
                      AddToCartEvent(
                        cartFood: food,
                        quantity: ref.read(counterProvider).count,
                      ),
                    );
                  },
                  child: Container(
                    height: screenSize.height * 0.07,
                    width: screenSize.width * 0.6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: screenSize.width * 0.05),
                        Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white, fontSize: screenSize.height * 0.02),
                        ),
                        SizedBox(width: screenSize.width * 0.03),
                        const Icon(Icons.add, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
