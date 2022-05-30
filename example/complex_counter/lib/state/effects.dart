import 'package:flutter/material.dart';
import 'package:flutter_rx/flutter_rx.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/mock_local_storage.dart';
import '../models/appState.dart';

import 'actions.dart';
import 'selectors.dart';

class WriteLocalStorageCounterData {
  WriteLocalStorageCounterData({this.action, this.value});
  WriteLocalStorageCounterAction action;
  int value;
}

// A `Effect` is just a function that handles an incoming stream of actions.
// Effects are intended to perform side effects upon receiving an action
// and can optionally return a new `StoreAction` which will be dispatched by the store
// This allows you to isolate side effects in your app such as network requests
// and dipatch a new action after the side effect is complete
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
      .withLatestFrom(store.select(selectCounter), (action, int value) {
        return WriteLocalStorageCounterData(action: action, value: value);
      })
      .switchMap((data) => Stream.fromFuture(
          mockLocalStorage.write(data.value).then((_) => data)))
      .map(
        (data) => WriteLocalStorageCounterSuccessAction(
          context: data.action.context,
          value: data.value,
        ),
      )
      .handleError((_) => WriteLocalStorageCounterFailAction());
};

// The effect below displays a snackbar with a success message when
// data has been written succesfully to local storage.
//
// Displaying a snack bar or dialog is common way to inidcate to the user
// the sucess or failure of a side effect (uplooading data, a failed login, etc.).
// Both of these tasks require the current BuildContext, which can be passed
// as a prop on the action
Effect<AppState> writeLocalStorageSuccessEffect = (
  Stream<StoreAction> actions,
  Store<AppState> store,
) {
  return actions
      .whereType<WriteLocalStorageCounterSuccessAction>()
      .map((action) {
    String message = 'Value of ${action.value} saved to local storage';
    ScaffoldMessenger.of(action.context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  });
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
  writeLocalStorageSuccessEffect,
  readLocalStorageEffect,
];

// storeEffects below will just have the two effects from localStorageEffects,
// but in a real app you would likely have many effects that may be
// defined in different location throughout the app
List<Effect<AppState>> storeEffects = [
  ...localStorageEffects,
];
