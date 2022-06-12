import 'package:flutter_rx_core/src/types.dart';

/// {@template flutter_rx_core.types.reducer}
/// A function that takes a [StoreAction] and a [State], and returns a new [State].
/// {@endtemplate}
typedef Reducer<State> = State Function(
  State state,
  StoreAction action,
);

/// A utility function that combines several [On] reducer objects.
///
/// ### Example
///
///     Reducer<int> counterReducer = createReducer([
///       On<int, IncrementCounterAction>(
///         (counter, action) => counter + 1,
///       ),
///       On<int, DecrementCounterAction>(
///         (counter, action) => counter - 1,
///       ),
///     ]);
Reducer<State> createReducer<State>(
  Iterable<On<State, StoreAction>> ons,
) {
  return (State state, StoreAction action) {
    for (final onAction in ons) {
      state = onAction(state, action);
    }
    return state;
  };
}

/// A special type of reducer object that will only run for a
/// specific [StoreAction].
///
/// ### Example
///
///     Reducer<int> counterReducer = createReducer([
///       On<int, IncrementCounterAction>(
///         (counter, action) => counter + 1,
///       ),
///       On<int, DecrementCounterAction>(
///         (counter, action) => counter - 1,
///       ),
///     ]);
class On<State, Action extends StoreAction> {
  final ActionReducer<State, Action> reducer;

  On(this.reducer);

  State call(State state, dynamic action) {
    if (action is Action) {
      return reducer(state, action);
    }
    return state;
  }
}
