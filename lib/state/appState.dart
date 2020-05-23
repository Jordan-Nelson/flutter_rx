import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final int counter;
  AppState({this.counter = 0});

  AppState copyWith({int counter}) {
    return AppState(
      counter: counter ?? this.counter,
    );
  }
}
