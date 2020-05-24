import 'package:flutter_rx/flutter_rx.dart';

import '../models/appState.dart';

import 'actions.dart';

// The reducer is a just a function that takes a `state` and
// and `action` and returns a new state
// The state of this application only has a counter
// but real applications will have state that is more complex
Reducer<AppState> reducer = (state, action) {
  return state.copyWith(
    counter: counterReducer(state.counter, action),
  );
};

// `createReducer` and `On<State, Action>` are just a utilities
// for creating more complex reducers
//
// `On<State, Action>` is a special type of reducer that
// accepts a specific action and a reducer funtion.
// The reducer function will be used if the action matches the
// specific type passed in. This is simialr to `TypedReduer` from
// the redux package.
//
// `createReducer` accepts a List of On Objects. It is similar to
// combineReducers from the redux package.
//
// The names `createReducer` and `On` both come from NgRx,
// which this library is based on
Reducer<int> counterReducer = createReducer([
  On<int, IncrementCounterAction>(
    (counter, action) => counter + 1,
  ),
  On<int, DecrementCounterAction>(
    (counter, action) => counter - 1,
  ),
  On<int, ChangeCounterByValueAction>(
    (counter, action) => counter + action.value,
  ),
  On<int, ResetCounterAction>(
    (counter, action) => 0,
  ),
  On<int, SetCounterAction>(
    (counter, action) => action.value,
  ),
]);

// The commented out code below is also a valid way to define the reducer without
// the use of utilities `createReducer` and `On<State, Action>`.
// For simple reducers, the use of these utilities may not provide as much value

// Reducer<int> counterReducer = (int counter, StoreAction action) {
//   if (action is IncrementCounterAction) {
//     return counter + 1;
//   }
//   if (action is DecrementCounterAction) {
//     return counter - 1;
//   }
//   if (action is ChangeCounterByValueAction) {
//     return counter + action.value;
//   }
//   if (action is ResetCounterAction) {
//     return 0;
//   }
//   if (action is SetCounterAction) {
//     return action.value;
//   }
//   return counter;
// };
