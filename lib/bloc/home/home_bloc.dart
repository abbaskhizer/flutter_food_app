import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final favoritesFirebase = FirebaseFirestore.instance.collection('user');
  final sharedPreferences = SharedPreferences.getInstance();
  HomeBloc() : super(HomeInitialState()) {
    var homeFirestore = FirebaseFirestore.instance.collection('menu').snapshots().asBroadcastStream();

    // ignore: invalid_use_of_visible_for_testing_member
    emit(HomeLoadedState(data: homeFirestore));
    on<FavoritesHomeEvent>((event, emit) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('uuId'))!;
      await favoritesFirebase.doc(userId).collection('favorites').doc(event.id).set(event.homeFood.copyWith(dateTime: DateTime.now()).toMap());
      emit(HomeLoadedState(data: homeFirestore));
    });
  }
  checkProductExistedInFavourites(String docId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = (sharedPreferences.getString('uuId'))!;
    var doc = await favoritesFirebase.doc(userId).collection('favorites').doc(docId).get();
    return doc.exists;
  }
}
