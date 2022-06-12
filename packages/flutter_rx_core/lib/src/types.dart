import 'package:flutter_rx_core/src/store.dart';
import 'package:flutter_rx_core/src/reducer.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// A base class for all Actions to extend.
/// This allows for type safety when dispatching actions
/// or handling actions in reducers or effects.
@immutable
abstract class StoreAction {
  const StoreAction();
}

/// The immutable state managed by the store.
@immutable
abstract class StoreState {
  const StoreState();
}

typedef Selector<S, T> = T Function(S state, dynamic props);

/// A [Reducer] function that accepts a [StoreAction] of a specific type.
typedef ActionReducer<State, Action extends StoreAction> = State Function(
  State state,
  Action action,
);

/// A function that handles an incoming stream of actions, optionally
/// performs side effects upon receiving an action, and optionally returns
/// a new `StoreAction` which will be dispatched by the store.
typedef Effect<State extends StoreState> = Stream<dynamic> Function(
  BehaviorSubject<StoreAction>,
  Store<State> store,
);
