

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/model/foodModelClass.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final favoritesFirebase = FirebaseFirestore.instance.collection('user');
 

  MenuBloc(BuildContext context) : super(MenuInitialState()) {
    var menuFirestore = FirebaseFirestore.instance.collection('menu').snapshots().asBroadcastStream();
    // ignore: invalid_use_of_visible_for_testing_member
    emit(MenuLoadedState(data: menuFirestore));
    
    on<FavoritesMenuEvent>((event, emit) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('userId'))!;
      await favoritesFirebase.doc(userId).collection('favorites').doc(event.id).set(event.menuFood.copyWith(dateTime: DateTime.now()).toMap());
      emit(MenuLoadedState(data: menuFirestore));
    });
     
  }
  checkProductExistedInFavourites(String docId) async {

      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('userId'))!;
    var doc = await favoritesFirebase.doc(userId).collection('favorites').doc(docId).get();
    return doc.exists;
  }

}

