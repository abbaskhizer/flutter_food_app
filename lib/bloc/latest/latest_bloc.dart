import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/modelClass/foodModelClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'latest_event.dart';
part 'latest_state.dart';

class LatestBloc extends Bloc<LatestEvent, LatestState> {
  final favoritesFirebase = FirebaseFirestore.instance.collection('user');
  final sharedPreferences = SharedPreferences.getInstance();
  LatestBloc() : super(LatestInitialState()) {
    var letestFirestore = FirebaseFirestore.instance.collection('letest').snapshots().asBroadcastStream();

    // ignore: invalid_use_of_visible_for_testing_member
    emit(LatestLoadedState(data: letestFirestore));

    on<FavoritesLatestEvent>((event, emit) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = (sharedPreferences.getString('uuId'))!;
      await favoritesFirebase.doc(userId).collection('favorites').doc(event.id).set(event.latestFood.copyWith(dateTime: DateTime.now()).toMap());
      emit(LatestLoadedState(data: letestFirestore));
    });
  }
  checkProductExistedInFavourites(String docId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = (sharedPreferences.getString('uuId'))!;
    var doc = await favoritesFirebase.doc(userId).collection('favorites').doc(docId).get();
    return doc.exists;
  }
}
