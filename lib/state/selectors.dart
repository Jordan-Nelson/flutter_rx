import 'package:flutter_rx/flutter_rx.dart';

import 'appState.dart';

Stream<int> selectCounterSimple(Stream<AppState> state) {
  return state.map((state) => state.counter);
}

Stream<int> selectCounter(Stream<AppState> state) {
  return createSelector(state, (AppState state) => state.counter);
}

Stream<int> selectCounter2(Stream<AppState> state) {
  return createSelector2(
    selectCounter(state),
    selectCounter(state),
    (int counter1, int counter2) {
      return counter1 + counter2;
    },
  );
}

Stream<int> selectCounter10(Stream<AppState> state) {
  return createSelector10(
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    selectCounter(state),
    (
      int c1,
      int c2,
      int c3,
      int c4,
      int c5,
      int c6,
      int c7,
      int c8,
      int c9,
      int c10,
    ) {
      return c1;
    },
  );
}
