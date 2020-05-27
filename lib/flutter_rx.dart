import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// Provides a [Store] to all descendants of this Widget. This should
/// generally be a root widget in your app and your app should only
/// conatin one [Store]. Connect to the Store provided by this Widget
/// using `StoreProvider.of<T>(context)`.
class StoreProvider<T> extends InheritedWidget {
  const StoreProvider({
    Key key,
    @required store,
    @required Widget child,
  })  : assert(store != null),
        assert(child != null),
        _store = store,
        super(key: key, child: child);

  final Store<T> _store;

  static Store<T> of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StoreProvider<T>>()
        ?._store;
  }

  @override
  bool updateShouldNotify(_) => false;
}

/// Build a widget based on the state of the [Store].
///
/// This widget is simply a wrapper around a [StreamBuilder].
/// The recommended approach is to use [StreamBuilder] directly,
/// but this widget abstracts away the use of stream for those
/// that prefer that approach
///
/// This widget is helpful in migrating from flutter_redux as it
/// has a similar interface to StoreConnector from flutter_redux
class StoreConnector<State, T> extends StatelessWidget {
  final Stream<T> Function(Stream<State>) selector;
  final Widget Function(BuildContext, T) builder;
  StoreConnector({@required this.selector, @required this.builder});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: StoreProvider.of<State>(context).select(selector),
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return builder(context, snapshot.data);
      },
    );
  }
}

/// A base class for all Actions to extend.
/// This allows for type safety when dispatching actions
/// or handling actions in reducers or effects.
class StoreAction {}

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

/// Creates a store that holds the app state.
///
/// The only way to change the state in the store is to [dispatch] an
/// action. The action will be sent to the provided [Reducer] to update the state.
///
/// The store will provide actions to each [Effect] after the reducer has
/// been run and a new state has been returned.
///
/// The store can be provided to a widget tree using [StoreProvider].
class Store<State> {
  Store({
    @required State initialState,
    this.reducer,
    this.effects,
  }) {
    assert(initialState != null);
    state.add(initialState);
    if (this.reducer != null) {
      actionStream.listen((StoreAction action) {
        State newState = this.reducer(state.value, action);
        state.add(newState);
        effectsActionStream.add(action);
      });
    }
    if (this.effects != null) {
      effects.forEach((Effect<State> effect) {
        return effect(this.effectsActionStream, this).listen((action) {
          if (action is StoreAction) {
            this.dispatch(action);
          }
        });
      });
    }
  }

  Reducer<State> reducer;
  List<Effect<State>> effects;
  BehaviorSubject<StoreAction> actionStream = BehaviorSubject<StoreAction>();
  BehaviorSubject<StoreAction> effectsActionStream =
      BehaviorSubject<StoreAction>();

  BehaviorSubject<State> state = BehaviorSubject<State>();

  Stream<K> select<K>(Stream<K> Function(Stream<State> state) mapFn) {
    return mapFn(this.state).distinct();
  }

  dispatch(StoreAction action) {
    actionStream.add(action);
  }
}

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

typedef Selector<State, AppState> = Stream<State> Function(Stream<AppState>);

/// A utility for creating a new [Selector] from a map function.
/// The selector will only emit distinct values.
///
/// ### Example
///     Selector<int, AppState> selectCounter = createSelector(
///       (AppState state) => state.counter,
///     );
Selector<R, AppState> createSelector<AppState, R>(
  R Function(AppState) mapFn,
) {
  return (stream) => stream.map(mapFn).distinct();
}

/// A utility for creating a new [Selector] from an existing
/// selector and a map function. The selector will only emit
/// distinct values.
///
/// ### Example
///     Selector<int, AppState> selectCounterSqared = createSelector1(
///       selectCounter,
///       (int value) => value * value,
///     );
Selector<R, AppState> createSelector1<AppState, S1, R>(
  Selector<S1, AppState> selector1,
  R Function(S1) mapFn,
) {
  return (stream) => selector1(stream).map(mapFn).distinct();
}

/// A utility for composing two [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
///
/// ### Example
///     Selector<int, AppState> mySelector = createSelector2(
///       mySelector1,
///       mySelector2,
///       (int a, int b) => a + b,
///     );
Selector<R, AppState> createSelector2<AppState, S1, S2, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  R Function(S1, S2) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom(
        selector2(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing three [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
///
/// ### Example
///     Selector<int, AppState> mySelector = createSelector2(
///       mySelector1,
///       mySelector2,
///       mySelector3,
///       (int a, int b, int c) => a + b + c,
///     );
Selector<R, AppState> createSelector3<AppState, S1, S2, S3, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  R Function(S1, S2, S3) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom2(
        selector2(stream),
        selector3(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing four [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
Selector<R, AppState> createSelector4<AppState, S1, S2, S3, S4, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  R Function(S1, S2, S3, S4) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom3(
        selector2(stream),
        selector3(stream),
        selector4(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing five [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
Selector<R, AppState> createSelector5<AppState, S1, S2, S3, S4, S5, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  R Function(S1, S2, S3, S4, S5) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom4(
        selector2(stream),
        selector3(stream),
        selector4(stream),
        selector5(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing six [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
Selector<R, AppState> createSelector6<AppState, S1, S2, S3, S4, S5, S6, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  Selector<S6, AppState> selector6,
  R Function(S1, S2, S3, S4, S5, S6) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom5(
        selector2(stream),
        selector3(stream),
        selector4(stream),
        selector5(stream),
        selector6(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing seven [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
Selector<R, AppState> createSelector7<AppState, S1, S2, S3, S4, S5, S6, S7, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  Selector<S6, AppState> selector6,
  Selector<S7, AppState> selector7,
  R Function(S1, S2, S3, S4, S5, S6, S7) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom6(
        selector2(stream),
        selector3(stream),
        selector4(stream),
        selector5(stream),
        selector6(stream),
        selector7(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing eight [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
Selector<R, AppState>
    createSelector8<AppState, S1, S2, S3, S4, S5, S6, S7, S8, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  Selector<S6, AppState> selector6,
  Selector<S7, AppState> selector7,
  Selector<S8, AppState> selector8,
  R Function(S1, S2, S3, S4, S5, S6, S7, S8) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom7(
        selector2(stream),
        selector3(stream),
        selector4(stream),
        selector5(stream),
        selector6(stream),
        selector7(stream),
        selector8(stream),
        mapFn,
      )
      .distinct();
}

/// A utility for composing nine [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
Selector<R, AppState>
    createSelector9<AppState, S1, S2, S3, S4, S5, S6, S7, S8, S9, R>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  Selector<S6, AppState> selector6,
  Selector<S7, AppState> selector7,
  Selector<S8, AppState> selector8,
  Selector<S9, AppState> selector9,
  R Function(S1, S2, S3, S4, S5, S6, S7, S8, S9) mapFn,
) {
  return (stream) => selector1(stream)
      .withLatestFrom8(
        selector2(stream),
        selector3(stream),
        selector4(stream),
        selector5(stream),
        selector6(stream),
        selector7(stream),
        selector8(stream),
        selector9(stream),
        mapFn,
      )
      .distinct();
}
