import 'package:flutter_rx/flutter_rx.dart';

import '../models/appState.dart';

// A selector is just a function that maps the state of the store to
// an new value.
//
// The selector below is a very simple example that maps the
// state to the value of the counter.
Selector<AppState, int> selectCounterSimple = (AppState state, props) {
  return state.counter;
};

// The selctor below is similar to the selctor above,
// but is created using the `createSelector` utility.
//
// `createSelector` will perform memoization. This can
// provide performance benefits, particularly with
// selectors that perform expensive computation.
Selector<AppState, int> selectCounter = createSelector(
  (AppState state, [_]) => state.counter,
);

// The selector below uses the second argument of props to calulate
// the returned value. Props can be use to pass in info like an
// id of an object to select that specific object from the store
Selector<AppState, int> selectCounterMultiplier = createSelector(
  (AppState state, props) {
    return state.counter * props;
  },
);

// This selector is not actually used in this example, but is
// included to show the ability to compose multiple selectors together.
// `createSelector2` is used to compose two other selectors together.
// The map function now maps the output of the two selectors to a
// new value.
Selector<AppState, int> selectCounterDouble = createSelector2(
  selectCounter,
  selectCounterMultiplier,
  (int a, int b) {
    return a + b;
  },
);
