import 'package:my_app/redux/store.dart';
import 'package:rxdart/rxdart.dart';

import '../mock_local_storage.dart';
import 'actions.dart';
import 'appState.dart';
import 'selectors.dart';

StoreEffect<AppState> delayedIncrementCounterEffect = (
  Stream<StoreAction> actions, {
  Store<AppState> store,
}) {
  return actions
      .whereType<DelayedIncrementCounterAction>()
      .delay(Duration(milliseconds: 1000))
      .map((event) => IncrementCounterAction());
};

StoreEffect<AppState> writeLocalStorageEffect = (
  Stream<StoreAction> actions, {
  Store<AppState> store,
}) {
  return actions
      .whereType<WriteLocalStorageCounterAction>()
      .withLatestFrom(selectCounter(store), (action, int value) => value)
      .switchMap((value) => Stream.fromFuture(mockLocalStorage.write(value)))
      .map((value) => WriteLocalStorageCounterSuccessAction())
      .handleError((_) => WriteLocalStorageCounterFailAction());
};

StoreEffect<AppState> readLocalStorageEffect = (
  Stream<StoreAction> actions, {
  Store<AppState> store,
}) {
  return actions
      .whereType<ReadLocalStorageCounterAction>()
      .switchMap((value) => Stream.fromFuture(mockLocalStorage.read()))
      .where((value) => value != null)
      .map((value) => SetCounterAction(value: value));
};

List<StoreEffect<AppState>> localStorageEffects = List.from([
  writeLocalStorageEffect,
  readLocalStorageEffect,
]);

List<StoreEffect<AppState>> timerEffects = List.from([
  delayedIncrementCounterEffect,
]);

List<StoreEffect<AppState>> storeEffects = [
  ...localStorageEffects,
  ...timerEffects
];
