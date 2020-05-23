import 'package:my_app/redux/store.dart';

import 'appState.dart';

Stream<int> selectCounter(Store<AppState> store) {
  return store.select((state) => state.counter);
}

Stream<int> selectCounterAlt(Store<AppState> store) {
  return createSelector(store.state, (AppState state) => state.counter);
}

Stream<int> selectCounter2(Store<AppState> store) {
  return createSelector2(
    selectCounter(store),
    selectCounter(store),
    (int counter1, int counter2) {
      return counter1;
    },
  );
}

Stream<int> selectCounter10(Store<AppState> store) {
  return createSelector10(
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
    selectCounter(store),
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
