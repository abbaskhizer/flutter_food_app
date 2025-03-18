import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/controller/riverpod/counterClass.dart';

class CounterStateNotifier extends StateNotifier<Counter> {
  CounterStateNotifier(super.state);
 void increment() {
  state=Counter(count: state.count+1);
 }
 void decrement(){
  if (state.count >0) {
    state=Counter(count: state.count-1);
  }
  
 }
}