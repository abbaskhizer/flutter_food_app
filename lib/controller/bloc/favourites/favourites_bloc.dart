import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  var sharedPreferences = SharedPreferences.getInstance();
  var id = DateTime.now().microsecondsSinceEpoch;

  FavouritesBloc(BuildContext context) : super(FavouritesInitialState()) {
    sharedPreferences.then((value) {
      String userId = value.getString('userId')!;
      // ignore: invalid_use_of_visible_for_testing_member
      emit(FavouritesLoadedState(data: FirebaseFirestore.instance.collection('user').doc(userId).collection('favorites').snapshots()));
    });
    on<FavouritesDeleteEvent>((event, emit) {
      sharedPreferences.then((value) async {
        String userId = value.getString('userId')!;
        Navigator.of(context).canPop();
          await FirebaseFirestore.instance.collection('user').doc(userId).collection('favorites').doc(event.documentId).delete();
     
      });
    });
  }
  
}
