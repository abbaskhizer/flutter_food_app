import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/view/screens/homeScreen.dart';
import 'package:foodie/view/screens/login.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  FirebaseAuth auth = FirebaseAuth.instance;
  SplashScreenCubit(BuildContext context) : super(SplashScreenInitialState()) {
    final user = auth.currentUser;

    if (user != null) {
      Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
          Navigator.of(context).pushReplacementNamed(HomeScreen.pagename));
    } else {
      Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
          Navigator.of(context).pushReplacementNamed(LoginScreen.pagename));
    }
  }
}
