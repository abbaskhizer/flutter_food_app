import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/Menu/menu_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';
import 'package:foodie/screens/cartscreen.dart';
import 'package:foodie/screens/fooddetailscreen.dart';

class MenuScreen extends StatelessWidget {
  static const pagename = '/menuScreen';
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
   
    var screenWidth = screenSize.width;
   

    return BlocProvider(
      create: (context) => MenuBloc(),
      child: Scaffold(
          appBar: AppBar(
            elevation: 3,
            backgroundColor: Colors.red,
            title: Text(
              'Our Menu',
              style: TextStyle(fontSize: screenWidth * 0.080, color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.pagename);
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ))
            ],
          ),
          body: BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case MenuInitialState:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  (state as MenuLoadedState);
                  return Center(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: StreamBuilder(
                              stream: state.data,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                                  return GridView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: screenWidth * 0.00001, crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      Food menuFood = Food.fromMap(snapshot.data!.docs[index].data());
                                      return FutureBuilder(
                                        future: BlocProvider.of<MenuBloc>(context).checkProductExistedInFavourites(snapshot.data!.docs[index].id),
                                        builder: (context, checkDoc) {
                                          if (checkDoc.hasData) {
                                            return Padding(
                                              padding: const EdgeInsets.all(25),
                                              child: Material(
                                                elevation: 3,
                                                borderRadius: BorderRadius.circular(30),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(FoodDetailScreen.pagename, arguments: menuFood
                                                        //
                                                        );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        // color: Colors.amber,

                                                        borderRadius: BorderRadius.circular(30)),
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
                                                              Text(
                                                                menuFood.name,
                                                                style: const TextStyle(fontSize: 12),
                                                              ),
                                                              Text('Rs: ${menuFood.price}'),
                                                            ],
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                BlocProvider.of<MenuBloc>(context).add(FavoritesMenuEvent(menuFood: menuFood, id: snapshot.data!.docs[index].id));
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
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return const Text('Something went wrong');
                                }
                              }),
                        ),
                      ],
                    ),
                  );
              }
            },
          )),
    );
  }
}
