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
        ._store;
  }

  @override
  bool updateShouldNotify(_) => false;
}

class StoreAction {}

/// A function that takes an `StoreAction` and a `State`, and returns a `State`.
typedef ActionReducer<State, Action extends StoreAction> = State Function(
  State state,
  Action action,
);

typedef Reducer<State> = State Function(
  State state,
  StoreAction action,
);

typedef StoreEffect<State> = Stream<StoreAction>
    Function(BehaviorSubject<StoreAction>, {Store<State> store});

class Store<State> {
  Store({
    State ititialValue,
    this.reducer,
    this.effects,
  }) {
    subject.add(ititialValue);
    actionStream.listen((StoreAction action) {
      State newState = this.reducer(subject.value, action);
      subject.add(newState);
      effectsActionStream.add(action);
    });
    effects.forEach((StoreEffect<State> effect) {
      return effect(this.effectsActionStream, store: this).listen((action) {
        if (action is StoreAction) {
          this.dispatch(action);
        }
      });
    });
  }

  Reducer<State> reducer;
  List<StoreEffect<State>> effects;
  BehaviorSubject<StoreAction> actionStream = BehaviorSubject<StoreAction>();
  BehaviorSubject<StoreAction> effectsActionStream =
      BehaviorSubject<StoreAction>();

  BehaviorSubject<State> subject = BehaviorSubject<State>();
  Stream<State> get state => this.subject;

  Stream<K> select<K>(K Function(State state) mapFn) {
    return this.state.map(mapFn).distinct();
  }

  dispatch(StoreAction action) {
    actionStream.add(action);
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

// Map<String, ActionReducer<State, StoreAction>> _actionMap =
//     Map<String, ActionReducer<State, StoreAction>>();

// onAction(
//   StoreAction action,
//   ActionReducer<State, StoreAction> actionHandler,
// ) {
//   _actionMap.update(
//     action.type,
//     (value) => actionHandler,
//     ifAbsent: () => actionHandler,
//   );
// }

// ActionReducer<State, StoreAction> handler = _actionMap[action.type];
// if (handler != null) {
//   this._state = handler(this._state, action);
//   controller.add(_state);
// }
