import './types.dart';
import 'package:rxdart/rxdart.dart';

/// Creates a store that holds the app's state.
///
/// The only way to change the state in the store is to [dispatch] an
/// action. The action will be sent to the provided [Reducer] to update the state.
///
/// Only after a new state is computed will the dispatched action be added to the
/// stream of actions that is provided to each [Effect].
class Store<S extends StoreState> {
  Store({
    required S initialState,
    this.reducer,
    this.effects,
  }) {
    state.add(initialState);
    if (reducer != null) {
      _actionStream.listen((StoreAction action) {
        S newState = reducer!(state.value, action);
        state.add(newState);
        _effectsActionStream.add(action);
      });
    }
    if (effects != null) {
      for (var effect in effects!) {
        effect(_effectsActionStream, this).listen((effectResult) {
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

  /// {@macro flutter_rx_core.types.reducer}
  Reducer<S>? reducer;

  /// A list of effects to be run after a new state is computed.
  List<Effect<S>>? effects;

  /// The stream of actions emitted.
  final _actionStream = BehaviorSubject<StoreAction>();

  /// A stream of actions used for effects.
  ///
  /// Actions are only added to this stream after a new state is computed.
  final _effectsActionStream = BehaviorSubject<StoreAction>();

  /// The store's state.
  final state = BehaviorSubject<S>();

  /// The current value of the state in the store.
  S get value => state.value;

  /// Stream the state of the of the store given a [Selector].
  Stream<R> select<R, P>(Selector<S, R> selector, [dynamic props]) {
    Stream<R> newStream =
        state.map((state) => selector(state, props)).distinct();
    BehaviorSubject<R> subject = BehaviorSubject();
    subject.add(selector(state.value, props));
    subject.addStream(newStream);
    return subject;
  }

  /// Dispatch a new action.
  ///
  /// A new state will be computed, and effewcts will subsequently run.
  dispatch(StoreAction action) {
    _actionStream.add(action);
  }
}
