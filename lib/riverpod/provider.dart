import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/riverpod/counterClass.dart';
import 'package:foodie/riverpod/counterStateNotifier.dart';




final counterProvider=StateNotifierProvider<CounterStateNotifier,Counter>((ref) {
  return CounterStateNotifier(const Counter(count: 0));
});






