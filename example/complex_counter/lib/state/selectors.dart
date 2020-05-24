import 'package:flutter_rx/flutter_rx.dart';

import '../models/appState.dart';

// A selector is just a function that maps an incoming stream to
// an outgoing stream. The incoming stream will be you applications state.
//
// The selector below is a very simple example that maps the
// state to the value of the counter
Stream<int> selectCounterSimple(Stream<AppState> state) {
  return state.map((state) => state.counter);
}

// The selctor below is equivelent to the selctor above,
// but is created using the `createSelector` utility.
//
// `createSelector` maps an incoming steam to an outgoing stream,
// using the provided map function.
// For a simple use case, `createSelector` does not provide much
// value, but for more complex examples `selectCounter` allows
// simple composition of multiple selctors. An example of that
// can be seen below
Stream<int> selectCounter(Stream<AppState> state) {
  return createSelector(state, (AppState state) => state.counter);
}

// This selector is not actually used in this example, but is
// included to show the ability to compose multiple selectors together.
// `createSelector2` is used to compose two other selectors together.
// The map function now has access to both of these values.
Stream<int> selectCounterDouble(Stream<AppState> state) {
  return createSelector2(
    selectCounter(state),
    selectCounter(state),
    (int counter1, int counter2) {
      return counter1 + counter2;
    },
  );
}
