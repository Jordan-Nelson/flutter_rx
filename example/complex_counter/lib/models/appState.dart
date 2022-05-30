import 'package:flutter/foundation.dart';
import 'package:flutter_rx/flutter_rx.dart';

@immutable
class AppState extends StoreState {
  final int counter;
  AppState({this.counter = 0});

  AppState copyWith({int counter}) {
    return AppState(
      counter: counter ?? this.counter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppState && counter == other.counter;

  @override
  int get hashCode => counter.hashCode;
}
