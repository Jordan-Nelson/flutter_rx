import './types.dart';
import 'package:rxdart/rxdart.dart';

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
    required State initialState,
    this.reducer,
    this.effects,
  }) {
    assert(initialState != null);
    state.add(initialState);
    if (reducer != null) {
      actionStream.listen((StoreAction action) {
        State newState = reducer!(state.value!, action);
        state.add(newState);
        effectsActionStream.add(action);
      });
    }
    if (effects != null) {
      for (var effect in effects!) {
        effect(effectsActionStream, this).listen((effectResult) {
          if (effectResult is StoreAction) {
            dispatch(effectResult);
          }
          if (effectResult is List &&
              effectResult.every((element) => element is StoreAction)) {
            for (var action in effectResult) {
              dispatch(action);
            }
          }
        });
      }
    }
  }

  Reducer<State>? reducer;
  List<Effect<State>>? effects;
  BehaviorSubject<StoreAction> actionStream = BehaviorSubject<StoreAction>();
  BehaviorSubject<StoreAction> effectsActionStream =
      BehaviorSubject<StoreAction>();

  BehaviorSubject<State> state = BehaviorSubject<State>();

  State get value => state.value;

  Stream<R> select<R, P>(Selector<State, R> selector, [dynamic props]) {
    Stream<R> newStream =
        state.map((state) => selector(state, props)).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    subject.add(selector(state.value!, props));
    subject.addStream(newStream);
    return subject;
  }

  dispatch(StoreAction action) {
    actionStream.add(action);
  }
}
