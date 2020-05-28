import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx/rx_stream_builder.dart';
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
    Stream<T> stream = StoreProvider.of<State>(context).select(selector);
    return RxStreamBuilder<T>(
      stream: stream,
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
    return mapFn(this.state);
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

typedef Selector<R, AppState> = Stream<R> Function(Stream<AppState>);
typedef BehaviorSubjectSelector<R, AppState> = BehaviorSubject<R> Function(
    Stream<AppState>);

/// A utility for creating a new [Selector] from a map function.
/// The selector will only emit distinct values.
///
/// ### Example
///     Selector<int, AppState> selectCounter = createSelector(
///       (AppState state) => state.counter,
///     );
BehaviorSubjectSelector<R, AppState> createSelector<R, AppState>(
  R Function(AppState) mapFn,
) {
  return (stream) {
    Stream<R> newStream = stream.map(mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if (stream is BehaviorSubject) {
      subject.add(mapFn((stream as BehaviorSubject).value));
    }
    subject.addStream(newStream);
    return subject;
  };
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
BehaviorSubjectSelector<R, AppState> createSelector1<R, AppState, S1>(
  Selector<S1, AppState> selector1,
  R Function(S1) mapFn,
) {
  return (stream) {
    Stream<S1> selectorStream = selector1(stream);
    Stream<R> newStream = selectorStream.map(mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if (selectorStream is BehaviorSubject) {
      subject.add(mapFn((selectorStream as BehaviorSubject).value));
    }
    subject.addStream(newStream);
    return subject;
  };
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
BehaviorSubjectSelector<R, AppState> createSelector2<R, AppState, S1, S2>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  R Function(S1, S2) mapFn,
) {
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<R> mappedStream = Rx.combineLatest2(s1, s2, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2].every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
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
BehaviorSubjectSelector<R, AppState> createSelector3<R, AppState, S1, S2, S3>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  R Function(S1, S2, S3) mapFn,
) {
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<R> mappedStream = Rx.combineLatest3(s1, s2, s3, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3].every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}

/// A utility for composing four [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
BehaviorSubjectSelector<R, AppState>
    createSelector4<R, AppState, S1, S2, S3, S4>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  R Function(S1, S2, S3, S4) mapFn,
) {
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<S4> s4 = selector4(stream);
    Stream<R> mappedStream =
        Rx.combineLatest4(s1, s2, s3, s4, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3, s4].every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
        (s4 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}

/// A utility for composing five [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
BehaviorSubjectSelector<R, AppState>
    createSelector5<R, AppState, S1, S2, S3, S4, S5>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  R Function(S1, S2, S3, S4, S5) mapFn,
) {
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<S4> s4 = selector4(stream);
    Stream<S5> s5 = selector5(stream);
    Stream<R> mappedStream =
        Rx.combineLatest5(s1, s2, s3, s4, s5, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3, s4, s5].every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
        (s4 as BehaviorSubject).value,
        (s5 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}

/// A utility for composing six [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
BehaviorSubjectSelector<R, AppState>
    createSelector6<R, AppState, S1, S2, S3, S4, S5, S6>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  Selector<S6, AppState> selector6,
  R Function(S1, S2, S3, S4, S5, S6) mapFn,
) {
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<S4> s4 = selector4(stream);
    Stream<S5> s5 = selector5(stream);
    Stream<S6> s6 = selector6(stream);
    Stream<R> mappedStream =
        Rx.combineLatest6(s1, s2, s3, s4, s5, s6, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3, s4, s5, s6]
        .every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
        (s4 as BehaviorSubject).value,
        (s5 as BehaviorSubject).value,
        (s6 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}

/// A utility for composing seven [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
BehaviorSubjectSelector<R, AppState>
    createSelector7<R, AppState, S1, S2, S3, S4, S5, S6, S7>(
  Selector<S1, AppState> selector1,
  Selector<S2, AppState> selector2,
  Selector<S3, AppState> selector3,
  Selector<S4, AppState> selector4,
  Selector<S5, AppState> selector5,
  Selector<S6, AppState> selector6,
  Selector<S7, AppState> selector7,
  R Function(S1, S2, S3, S4, S5, S6, S7) mapFn,
) {
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<S4> s4 = selector4(stream);
    Stream<S5> s5 = selector5(stream);
    Stream<S6> s6 = selector6(stream);
    Stream<S7> s7 = selector7(stream);
    Stream<R> mappedStream =
        Rx.combineLatest7(s1, s2, s3, s4, s5, s6, s7, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3, s4, s5, s6, s7]
        .every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
        (s4 as BehaviorSubject).value,
        (s5 as BehaviorSubject).value,
        (s6 as BehaviorSubject).value,
        (s7 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}

/// A utility for composing eight [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
BehaviorSubjectSelector<R, AppState>
    createSelector8<R, AppState, S1, S2, S3, S4, S5, S6, S7, S8>(
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
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<S4> s4 = selector4(stream);
    Stream<S5> s5 = selector5(stream);
    Stream<S6> s6 = selector6(stream);
    Stream<S7> s7 = selector7(stream);
    Stream<S8> s8 = selector8(stream);
    Stream<R> mappedStream =
        Rx.combineLatest8(s1, s2, s3, s4, s5, s6, s7, s8, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3, s4, s5, s6, s7, s8]
        .every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
        (s4 as BehaviorSubject).value,
        (s5 as BehaviorSubject).value,
        (s6 as BehaviorSubject).value,
        (s7 as BehaviorSubject).value,
        (s8 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}

/// A utility for composing nine [Selector] functions together to
/// create a new [Selector]. The selector will only emit distinct values.
BehaviorSubjectSelector<R, AppState>
    createSelector9<R, AppState, S1, S2, S3, S4, S5, S6, S7, S8, S9>(
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
  return (stream) {
    Stream<S1> s1 = selector1(stream);
    Stream<S2> s2 = selector2(stream);
    Stream<S3> s3 = selector3(stream);
    Stream<S4> s4 = selector4(stream);
    Stream<S5> s5 = selector5(stream);
    Stream<S6> s6 = selector6(stream);
    Stream<S7> s7 = selector7(stream);
    Stream<S8> s8 = selector8(stream);
    Stream<S9> s9 = selector9(stream);
    Stream<R> mappedStream =
        Rx.combineLatest9(s1, s2, s3, s4, s5, s6, s7, s8, s9, mapFn).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    if ([s1, s2, s3, s4, s5, s6, s7, s8, s9]
        .every((element) => element is BehaviorSubject)) {
      subject.add(mapFn(
        (s1 as BehaviorSubject).value,
        (s2 as BehaviorSubject).value,
        (s3 as BehaviorSubject).value,
        (s4 as BehaviorSubject).value,
        (s5 as BehaviorSubject).value,
        (s6 as BehaviorSubject).value,
        (s7 as BehaviorSubject).value,
        (s8 as BehaviorSubject).value,
        (s9 as BehaviorSubject).value,
      ));
    }
    subject.addStream(mappedStream);
    return subject;
  };
}
