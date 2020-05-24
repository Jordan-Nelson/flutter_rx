import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

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

class StoreAction {}

/// /// A [Reducer] function that only accepts a [StoreAction] of a specific type
typedef ActionReducer<State, Action extends StoreAction> = State Function(
  State state,
  Action action,
);

/// A function that takes an [StoreAction] and a [State], and returns a [State].
typedef Reducer<State> = State Function(
  State state,
  StoreAction action,
);

typedef Effect<State> = Stream<dynamic> Function(
  BehaviorSubject<StoreAction>,
  Store<State> store,
);

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

Stream<R> createSelector<S, R>(
  Stream<S> state,
  R Function(S) fn,
) {
  return state.map(fn).distinct();
}

Stream<R> createSelector2<A, B, R>(
  Stream<A> state1,
  Stream<B> state2,
  R Function(A, B) fn,
) {
  return state1.withLatestFrom(state2, fn).distinct();
}

Stream<R> createSelector3<A, B, C, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  R Function(A, B, C) fn,
) {
  return state1.withLatestFrom2(state2, state3, fn).distinct();
}

Stream<R> createSelector4<A, B, C, D, R>(
  Stream<A> state1,
  Stream<B> state2,
  Stream<C> state3,
  Stream<D> state4,
  R Function(A, B, C, D) fn,
) {
  return state1.withLatestFrom3(state2, state3, state4, fn).distinct();
}

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
