import 'package:flutter_rx/flutter_rx.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/mock_local_storage.dart';
import '../models/appState.dart';

import 'actions.dart';
import 'selectors.dart';

// A `Effect` is just a function that maps an incoming stream of actions to
// a new stream of actions after optionally perfoming a side effect.
// This allows you to isolate side effects in your app such as network requests
//
// The effect below writes to a (mock) local storage, which happens asynchonously.
// The effect uses withLatestFrom to select the current counter value from the store.
// The effect maps the initial action to either a WriteLocalStorageCounterSuccessAction
// or a WriteLocalStorageCounterFailAction action, which will be dispatched by the store
Effect<AppState> writeLocalStorageEffect = (
  Stream<StoreAction> actions,
  Store<AppState> store,
) {
  return actions
      .whereType<WriteLocalStorageCounterAction>()
      .withLatestFrom(store.select(selectCounter), (action, int value) => value)
      .switchMap((value) => Stream.fromFuture(mockLocalStorage.write(value)))
      .map((value) => WriteLocalStorageCounterSuccessAction())
      .handleError((_) => WriteLocalStorageCounterFailAction());
};

// The effect below reads from a (mock) local storage, which happens asynchonously.
// On a successful read a SetCounterAction is returned,
// which will be dispatched by the store
Effect<AppState> readLocalStorageEffect = (
  Stream<StoreAction> actions,
  Store<AppState> store,
) {
  return actions
      .whereType<ReadLocalStorageCounterAction>()
      .switchMap((value) => Stream.fromFuture(mockLocalStorage.read()))
      .where((value) => value != null)
      .map((value) => SetCounterAction(value: value));
};

List<Effect<AppState>> localStorageEffects = [
  writeLocalStorageEffect,
  readLocalStorageEffect,
];

// storeEffects below will just have the two effects from localStorageEffects,
// but in a real app you would likely have many effects that may be
// defined in different location throughout the app
List<Effect<AppState>> storeEffects = [
  ...localStorageEffects,
];
