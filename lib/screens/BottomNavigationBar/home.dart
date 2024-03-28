import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foodie/bloc/home/home_bloc.dart';
import 'package:foodie/bloc/latest/latest_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';
import 'package:foodie/screens/cartscreen.dart';

import 'package:foodie/screens/fooddetailscreen.dart';

class HomeBarScreen extends StatelessWidget {
  static const pagename = '/homeBarScreen';
  const HomeBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    var clintHeight = screenHeight - kToolbarHeight;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => LatestBloc(),
        )
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
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.pagename);
              },
            )
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<LatestBloc, LatestState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case LatestInitialState:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    (state as LatestLoadedState);
                    return Expanded(
                        flex: 2,
                        child: Material(
                          elevation: 3,
                          shadowColor: Colors.red,
                          child: StreamBuilder(
                              stream: state.data,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator(color: Colors.red,));
                                } else if (snapshot.hasData) {
                                  return GridView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: screenWidth * 0.060, crossAxisCount: 1),
                                    itemBuilder: (context, index) {
                                      Food letestfood = Food.fromMap(snapshot.data!.docs[index].data());

                                      return FutureBuilder(
                                        future: BlocProvider.of<LatestBloc>(context).checkProductExistedInFavourites(snapshot.data!.docs[index].id),
                                        builder: (context, checkedDoc) {
                                          if (checkedDoc.hasData) {
                                            return Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Material(
                                                elevation: 3,
                                                borderRadius: BorderRadius.circular(30),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(FoodDetailScreen.pagename, arguments: letestfood);
                                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodDetailScreen(),));
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
                                                                radius: 25.0,
                                                                child: Hero(
                                                                  tag: 'food_image$index',
                                                                  child: Image.network(
                                                                    letestfood.imageURL,
                                                                    filterQuality: FilterQuality.high,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                letestfood.name,
                                                                style: const TextStyle(fontSize: 12),
                                                              ),
                                                              Text('Rs: ${letestfood.price}', style: const TextStyle(fontSize: 12)),
                                                            ],
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                BlocProvider.of<LatestBloc>(context).add(FavoritesLatestEvent(latestFood: letestfood, id: snapshot.data!.docs[index].id.toString()));
                                                              },
                                                              icon: checkedDoc.data == true
                                                                  ? const Icon(
                                                                      CupertinoIcons.heart_fill,
                                                                      color: Colors.redAccent,
                                                                    )
                                                                  : const Icon(Icons.favorite_border)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return const Text('SomeThing went Wrong');
                                }
                              }),
                        ));
                }
              },
            ),
            SizedBox(
              height: clintHeight * 0.005,
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case HomeInitialState:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    (state as HomeLoadedState);
                    return Expanded(
                        flex: 8,
                        child: StreamBuilder(
                            stream: state.data,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
                                return GridView.builder(
                                  itemCount: (snapshot.data!.docs.length / 2).toInt(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: screenWidth * 0.00001, crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    Food homeFood = Food.fromMap(snapshot.data!.docs[index].data());
                                    return FutureBuilder(
                                      future: BlocProvider.of<HomeBloc>(context).checkProductExistedInFavourites(snapshot.data.docs[index].id.toString()),
                                      builder: (context, checkDoc) {
                                        if (checkDoc.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.all(25),
                                            child: Material(
                                              elevation: 3,
                                              borderRadius: BorderRadius.circular(30),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(FoodDetailScreen.pagename, arguments: homeFood);
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
                                                              // flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                                                              //   return RotationTransition(
                                                              //     turns: animation,
                                                              //     child: const FoodDetailScreen(),
                                                              //   );
                                                              // },
                                                              tag: homeFood.imageURL,
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.white,
                                                                radius: 35.0,
                                                                child: Image.network(homeFood.imageURL),
                                                              ),
                                                            ),
                                                            Text(
                                                              homeFood.name,
                                                              style: const TextStyle(fontSize: 12),
                                                            ),
                                                            Text('Rs: ${homeFood.price}')
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              BlocProvider.of<HomeBloc>(context).add(FavoritesHomeEvent(homeFood: homeFood, id: snapshot.data!.docs[index].id.toString()));
                                                            },
                                                            icon: checkDoc.data == true
                                                                ? const Icon(
                                                                    CupertinoIcons.heart_fill,
                                                                    color: Colors.redAccent,
                                                                  )
                                                                : const Icon(Icons.favorite_border)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              } else {
                                return const Text('SomeThing Went Wrong');
                              }
                            }));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
