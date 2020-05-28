import 'package:flutter_rx/flutter_rx.dart';

import '../models/appState.dart';

// A selector is just a function that maps an incoming stream to
// an outgoing stream. The incoming stream will be the applications state.
//
// The selector below is a very simple example that maps the
// state to the value of the counter.
Selector<int, AppState> selectCounterSimple = (Stream<AppState> state) {
  return state.map((state) => state.counter);
};

// The selctor below is mostly the same as the selctor above,
// but is created using the `createSelector` utility.
//
// `createSelector` maps an incoming steam to an outgoing stream,
// using the provided map function.
//
// `createSelector` does two other important things.
//   1. It will only emit values that are not equivelent
//      to the previous value. This prevent prevents unnecessary
//      rebuilds and helps avoids unnecessary computation when
//      composing selectors together
//   2. It will return a BehaviorSubject. BehaviorSubjects store the
//      previous value, which is helpful when using StreamBuilder to
//      build a widget from a stream that already has data. This is
//      only true if the selector and any selectors it is made up of
//      were all created with `createSelector`,
//
// `createSelector` is not required to create selectors, but it
// highly recommended.
Selector<int, AppState> selectCounter = createSelector(
  (AppState state) => state.counter,
);

Selector<int, AppState> selectCounterAlt = createSelector1(
  selectCounterSimple,
  (int value) => value,
);

// This selector is not actually used in this example, but is
// included to show the ability to compose multiple selectors together.
// `createSelector2` is used to compose two other selectors together.
// The map function now has access to both of these values.
Selector<int, AppState> selectCounterDouble = createSelector2(
  selectCounter,
  selectCounterSimple,
  (int a, int b) {
    return a + b;
  },
);
