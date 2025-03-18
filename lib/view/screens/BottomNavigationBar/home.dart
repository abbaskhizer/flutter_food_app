
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:foodie/controller/bloc/home/home_bloc.dart';
import 'package:foodie/controller/bloc/latest/latest_bloc.dart';
import 'package:foodie/model/foodModelClass.dart';
import 'package:foodie/view/screens/cartscreen.dart';
import 'package:foodie/view/screens/fooddetailscreen.dart';

class HomeBarScreen extends StatelessWidget {
  static const pagename = '/homeBarScreen';
  
  const HomeBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    var clientHeight = screenHeight - kToolbarHeight;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc(context)),
        BlocProvider(create: (context) => LatestBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          shadowColor: Colors.black,
          backgroundColor: Colors.red,
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.040),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.pagename);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<LatestBloc, LatestState>(
              builder: (context, state) {
                if (state is LatestInitialState) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 150,
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // Number of shimmer items
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is LatestLoadedState) {
                  return Expanded(
                    flex: 2,
                    child: Material(
                      elevation: 3,
                      shadowColor: Colors.red,
                      child: StreamBuilder(
                        stream: state.data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 150,
                                color: Colors.white,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3, // Number of shimmer items
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 120,
                                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return GridView.builder(
                              itemCount: snapshot.data!.docs.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: screenWidth * 0.060,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, index) {
                                Food food = Food.fromMap(snapshot.data!.docs[index].data());
                                String id = snapshot.data!.docs[index].id;
                                return FutureBuilder(
                                  future: BlocProvider.of<LatestBloc>(context).checkProductExistedInFavourites(id),
                                  builder: (context, checkedDoc) {
                                    if (checkedDoc.connectionState == ConnectionState.waiting) {
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
                                            Navigator.of(context).pushNamed(FoodDetailScreen.pagename, arguments: food);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Hero(
                                                        tag: food.id,
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.white,
                                                          radius: 25.0,
                                                          child: Image.network(food.imageURL, filterQuality: FilterQuality.high),
                                                        ),
                                                      ),
                                                      Text(food.name, style: const TextStyle(fontSize: 12)),
                                                      Text('Rs: ${food.price}', style: const TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      BlocProvider.of<LatestBloc>(context).add(FavoritesLatestEvent(latestFood: food, id: id));
                                                    },
                                                    icon: checkedDoc.data == true
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
                          } else {
                            return const Center(child: Text('Something went wrong with the latest foods.', style: TextStyle(color: Colors.red)));
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Something went wrong with the latest foods.', style:  TextStyle(color: Colors.red)));
                }
              },
            ),
            SizedBox(height: clientHeight * 0.005),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeInitialState) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: 4, // Number of shimmer items
                      itemBuilder: (context, index) {
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is HomeLoadedState) {
                  return Expanded(
                    flex: 8,
                    child: StreamBuilder(
                      stream: state.data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: 4, // Number of shimmer items
                              itemBuilder: (context, index) {
                          
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.vertical,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: screenWidth * 0.050,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              Food food = Food.fromMap(snapshot.data!.docs[index].data());
                              String id = snapshot.data!.docs[index].id;
                              return FutureBuilder(
                                future: BlocProvider.of<HomeBloc>(context).checkProductExistedInFavourites(snapshot.data!.docs[index].id),
                                builder: (context, checkedDoc) {
                                  if (checkedDoc.connectionState == ConnectionState.waiting) {
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
                                          Navigator.of(context).pushNamed(FoodDetailScreen.pagename, arguments: food);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Hero(
                                                      tag: snapshot.data!.docs[index].id,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        radius: 35.0,
                                                        child: Image.network(food.imageURL, filterQuality: FilterQuality.high),
                                                      ),
                                                    ),
                                                    Text(food.name, style: const TextStyle(fontSize: 12)),
                                                    Text('Rs: ${food.price}', style: const TextStyle(fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child:  IconButton(
                                                    onPressed: () {
                                                      BlocProvider.of<HomeBloc>(context).add(FavoritesHomeEvent(homeFood: food, id: id));
                                                    },
                                                    icon: checkedDoc.data == true
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
                        } else {
                          return const Center(child: Text('Something went wrong with home foods.', style: TextStyle(color: Colors.red)));
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Something went wrong with home foods.', style: TextStyle(color: Colors.red)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
