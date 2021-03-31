import './store.dart';
import 'package:rxdart/rxdart.dart';

/// A base class for all Actions to extend.
/// This allows for type safety when dispatching actions
/// or handling actions in reducers or effects.
class StoreAction {}

typedef Selector<S, T> = T Function(S state, dynamic props);

/// A function that takes a [StoreAction] and a [State], and returns a new [State].
typedef Reducer<State> = State Function(
  State state,
  StoreAction action,
);

/// A [Reducer] function that accepts a [StoreAction] of a specific type.
typedef ActionReducer<State, Action extends StoreAction> = State Function(
  State state,
  Action action,
);

/// A function that handles an incoming stream of actions, optionally
/// performs side effects upon receiving an action, and optionally returns
/// a new `StoreAction` which will be dispatched by the store.
typedef Effect<State> = Stream<dynamic> Function(
  BehaviorSubject<StoreAction>,
  Store<State> store,
);
