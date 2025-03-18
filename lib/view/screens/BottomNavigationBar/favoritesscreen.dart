
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/favourites/favourites_bloc.dart';
import 'package:foodie/model/foodModelClass.dart';
import 'package:foodie/view/screens/fooddetailscreen.dart';

class FavoritesScreen extends StatefulWidget {
  static const pagename = '/favouriteScreen';

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider<FavouritesBloc>(
      create: (context) => FavouritesBloc(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 3,
          backgroundColor: Colors.red,
          title: Text(
            'Favorite Items',
            style: TextStyle(fontSize: screenSize.width * 0.08, color: Colors.white),
          ),
        ),
        body: BlocBuilder<FavouritesBloc, FavouritesState>(
          builder: (context, state) {
            if (state is FavouritesInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavouritesLoadedState) {
              return StreamBuilder(
                stream: state.data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading favorites'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No favorite items found'));
                  }

                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final food = Food.fromMap(snapshot.data!.docs[index].data());
                      final id = snapshot.data!.docs[index].id;

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(onTap: () => Navigator.of(context).pushNamed(FoodDetailScreen.pagename,arguments: food),
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(30),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 35.0,
                                        child: Image.network(food.imageURL),
                                      ),
                                      Text(food.name, style: const TextStyle(fontSize: 12)),
                                      Text('Rs: ${food.price}'),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _showMyFavoritesDialog(id, context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
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

  Future<void> _showMyFavoritesDialog(String id, BuildContext context) async {
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
                BlocProvider.of<FavouritesBloc>(context).add(FavouritesDeleteEvent(documentId: id));
                Navigator.of(dialogContext).pop(); // Close dialog after action
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          title: const Text(
            'Do you want to remove From Favorites?',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      },
    );
  }
}
