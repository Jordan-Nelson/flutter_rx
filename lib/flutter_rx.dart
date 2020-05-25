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
    subject.add(initialState);
    if (this.reducer != null) {
      actionStream.listen((StoreAction action) {
        State newState = this.reducer(subject.value, action);
        subject.add(newState);
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

  BehaviorSubject<State> subject = BehaviorSubject<State>();
  Stream<State> get state => this.subject;

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
Reducer<State> createReducer<State, Action extends StoreAction>(
  Iterable<On<State, Action>> ons,
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

/// A utility for mapping an incoming stream to a new stream. The new
/// stream will only emit distinct values.
///
/// ### Example
///     Stream<int> selectCounter(Stream<AppState> state) {
///       return createSelector(state, (AppState state) => state.counter);
///     }
Stream<R> createSelector<S, R>(
  Stream<S> state,
  R Function(S) fn,
) {
  return state.map(fn).distinct();
}

/// A utility for mapping two incoming streams to a new stream. The new
/// stream will only emit distinct values.
///
/// ### Example
///     Stream<int> mySelector(Stream<AppState> state) {
///       return createSelector2(
///         mySelector1(state),
///         mySelector2(state),
///         (int a, int b) {
///           return a + b;
///         },
///       );
///     }
Stream<R> createSelector2<A, B, R>(
  Stream<A> state1,
  Stream<B> state2,
  R Function(A, B) fn,
) {
  return state1.withLatestFrom(state2, fn).distinct();
}

/// A utility for mapping three incoming streams to a new stream. The new
/// stream will only emit distinct values.
///
/// ### Example
///     Stream<int> mySelector(Stream<AppState> state) {
///       return createSelector3(
///         mySelector1(state),
///         mySelector2(state),
///         mySelector3(state),
///         (int a, int b, int c) {
///           return a + b + c;
///         },
///       );
///     }
Stream<R> createSelector3<A, B, C, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  R Function(A, B, C) fn,
) {
  return state1.withLatestFrom2(state2, state3, fn).distinct();
}

/// A utility for mapping four incoming streams to a new stream. The new
/// stream will only emit distinct values.
///
/// ### Example
///     Stream<int> mySelector(Stream<AppState> state) {
///       return createSelector3(
///         mySelector1(state),
///         mySelector2(state),
///         mySelector3(state),
///         mySelector4(state),
///         (int a, int b, int c, int d) {
///           return a + b + c + d;
///         },
///       );
///     }
Stream<R> createSelector4<A, B, C, D, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  R Function(A, B, C, D) fn,
) {
  return state1.withLatestFrom3(state2, state3, state4, fn).distinct();
}

/// A utility for mapping five incoming streams to a new stream. The new
/// stream will only emit distinct values.
Stream<R> createSelector5<A, B, C, D, E, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  Stream<E> state5,
  R Function(A, B, C, D, E) fn,
) {
  return state1.withLatestFrom4(state2, state3, state4, state5, fn).distinct();
}

/// A utility for mapping six incoming streams to a new stream. The new
/// stream will only emit distinct values.
Stream<R> createSelector6<A, B, C, D, E, F, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  Stream<E> state5,
  Stream<F> state6,
  R Function(A, B, C, D, E, F) fn,
) {
  return state1
      .withLatestFrom5(state2, state3, state4, state5, state6, fn)
      .distinct();
}

/// A utility for mapping seven incoming streams to a new stream. The new
/// stream will only emit distinct values.
Stream<R> createSelector7<A, B, C, D, E, F, G, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  Stream<E> state5,
  Stream<F> state6,
  Stream<G> state7,
  R Function(A, B, C, D, E, F, G) fn,
) {
  return state1
      .withLatestFrom6(state2, state3, state4, state5, state6, state7, fn)
      .distinct();
}

/// A utility for mapping eight incoming streams to a new stream. The new
/// stream will only emit distinct values.
Stream<R> createSelector8<A, B, C, D, E, F, G, H, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  Stream<E> state5,
  Stream<F> state6,
  Stream<G> state7,
  Stream<H> state8,
  R Function(A, B, C, D, E, F, G, H) fn,
) {
  return state1
      .withLatestFrom7(
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        fn,
      )
      .distinct();
}

/// A utility for mapping nine incoming streams to a new stream. The new
/// stream will only emit distinct values.
Stream<R> createSelector9<A, B, C, D, E, F, G, H, I, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  Stream<E> state5,
  Stream<F> state6,
  Stream<G> state7,
  Stream<H> state8,
  Stream<I> state9,
  R Function(A, B, C, D, E, F, G, H, I) fn,
) {
  return state1
      .withLatestFrom8(
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        state9,
        fn,
      )
      .distinct();
}

/// A utility for mapping ten incoming streams to a new stream. The new
/// stream will only emit distinct values.
Stream<R> createSelector10<A, B, C, D, E, F, G, H, I, J, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  Stream<E> state5,
  Stream<F> state6,
  Stream<G> state7,
  Stream<H> state8,
  Stream<I> state9,
  Stream<J> state10,
  R Function(A, B, C, D, E, F, G, H, I, J) fn,
) {
  return state1
      .withLatestFrom9(
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        state9,
        state10,
        fn,
      )
      .distinct();
}
