import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/favourites/favourites_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';
import 'package:foodie/screens/mydialog.dart';

class FavoritesScreen extends StatefulWidget {
  static const pagename = '/favouriteScreen';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    // ignore: unused_local_variable
    var clintHeight = screenHeight - kToolbarHeight;
    return BlocProvider<FavouritesBloc>(
      create: (context) => FavouritesBloc(context),
      child: Scaffold(
          appBar: AppBar(centerTitle: true,
            elevation: 3,
            backgroundColor: Colors.red,
            title: Text(
              'Favorite Items',
              style:
                  TextStyle(fontSize: screenWidth * 0.080, color: Colors.white),
            ),
          ),
          body: BlocBuilder<FavouritesBloc, FavouritesState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case FavouritesInitialState:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  (state as FavouritesLoadedState);
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
                                    itemCount: snapshot.data!.docs.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing:
                                                screenWidth * 0.00001,
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      Food favoritesFood = Food.fromMap(
                                          snapshot.data!.docs[index].data());
                                      return Padding(
                                        padding: const EdgeInsets.all(25),
                                        child: Material(
                                          elevation: 3,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                // color: Colors.amber,

                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 35.0,
                                                        child: Image.network(
                                                            favoritesFood
                                                                .imageURL),
                                                      ),
                                                      Text(
                                                        favoritesFood.name,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                          'Rs: ${favoritesFood.price}'),
                                                    ],
                                                  ),
                                                  
                                                ),
                                                 Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                        onPressed: () {
                                                         showMyFavoritesDialog(snapshot.data!.docs[index].id, context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                        )),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
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
