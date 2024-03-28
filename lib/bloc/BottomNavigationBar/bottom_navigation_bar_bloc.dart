

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_bar_event.dart';
part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarBloc extends Bloc<BottomNavigationBarEvent, BottomNavigationBarState> {
  BottomNavigationBarBloc() : super(const BottomNavigationBarInitialState(tabIndex: 0)) {
    on<BottomNavigationBarEvent>((event, emit) {
      if (event is TabChange) {
        emit(BottomNavigationBarInitialState(tabIndex: event.tabIndex));

        
      }
      
    });
  }
}
