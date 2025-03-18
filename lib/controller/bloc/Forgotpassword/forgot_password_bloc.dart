


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final _auth=FirebaseAuth.instance;
  ForgotPasswordBloc() : super(ForgotPasswordInitialState()) {

    on<ForgotPasswordButton>((event, emit) {
      emit(ForgotPasswordLoadingState());
      try {
        _auth.sendPasswordResetEmail(email: event.email);
emit(ForgotPasswordLoadedState());
        
      } catch (e) {
        emit(ForgotPasswordErrorState(errorMessage: e.toString()));
        
      }

    
    });
  }
}
