
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/Menu/menu_bloc.dart';
import 'package:foodie/model/foodModelClass.dart';
import 'package:foodie/view/screens/cartscreen.dart';
import 'package:foodie/view/screens/fooddetailscreen.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

class MenuScreen extends StatelessWidget {
  static const pagename = '/menuScreen';

  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;

    return BlocProvider(
      create: (context) => MenuBloc(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Colors.red,
          title: Text(
            'Our Menu',
            style: TextStyle(fontSize: screenWidth * 0.08, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.pagename);
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ],
        ),
        body: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuInitialState) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: GridView.builder(
                  itemCount: 1, // Number of shimmer items
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    );
                  },
                ),
              );
            } else if (state is MenuLoadedState) {
              return StreamBuilder(
                stream: state.data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GridView.builder(
                        itemCount: 1, // Number of shimmer items
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading menu'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No menu items available'));
                  } else {
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        Food menuFood = Food.fromMap(snapshot.data!.docs[index].data());
                        String id = snapshot.data!.docs[index].id;

                        return FutureBuilder(
                          future: BlocProvider.of<MenuBloc>(context).checkProductExistedInFavourites(id),
                          builder: (context, checkDoc) {
                            if (checkDoc.connectionState == ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration:const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            height: 10,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 10,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                          

                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(30),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(FoodDetailScreen.pagename, arguments: menuFood);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 35.0,
                                                child: Image.network(menuFood.imageURL),
                                              ),
                                              Text(menuFood.name, style: const TextStyle(fontSize: 12)),
                                              Text('Rs: ${menuFood.price}'),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child:  IconButton(
                                                    onPressed: () {
                                                      BlocProvider.of<MenuBloc>(context).add(FavoritesMenuEvent(menuFood: menuFood, id: id));
                                                    },
                                                    icon: checkDoc.data== true
                                                        ? const Icon(CupertinoIcons.heart_fill, color: Colors.redAccent)
                                                        : const Icon(Icons.favorite_border),
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
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
}
