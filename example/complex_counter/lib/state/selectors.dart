import 'package:flutter_rx/flutter_rx.dart';

import '../models/appState.dart';

// A selector is just a function that maps an incoming stream to
// an outgoing stream. The incoming stream will be the applications state.
//
// The selector below is a very simple example that maps the
// state to the value of the counter
Selector<int, AppState> selectCounterSimple = (Stream<AppState> state) {
  return state.map((state) => state.counter);
};

// The selctor below is equivelent to the selctor above,
// but is created using the `createSelector` utility.
//
// `createSelector` maps an incoming steam to an outgoing stream,
// using the provided map function.
// `createSelector` is not required to create selectors, but it
// provides an easier way to create selectors, and creates selectors
// that will only emit distinct values which improves performance.
Selector<int, AppState> selectCounter = createSelector(
  (AppState state) => state.counter,
);

// This selector is not actually used in this example, but is
// included to show the ability to compose multiple selectors together.
// `createSelector2` is used to compose two other selectors together.
// The map function now has access to both of these values.
Selector<int, AppState> selectCounterDouble = createSelector2(
  selectCounterSimple,
  selectCounter,
  (int counter1, int counter2) {
    return counter1 + counter2;
  },
);
