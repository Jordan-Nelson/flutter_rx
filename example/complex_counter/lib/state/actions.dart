import 'package:flutter/material.dart';
import 'package:flutter_rx/flutter_rx.dart';

// An action to increment the counter by 1
class IncrementCounterAction extends StoreAction {}

// An action to decrement the counter by 1
class DecrementCounterAction extends StoreAction {}

// An action to reset the counter to 0
class ResetCounterAction extends StoreAction {}

// An action to set the counter to a specific value
class SetCounterAction extends StoreAction {
  SetCounterAction({@required this.value});
  int value;
}

// An action to change the counter by a specific value
class ChangeCounterByValueAction extends StoreAction {
  ChangeCounterByValueAction({@required this.value});
  int value;
}

// An action to read the counter value from local storage
class ReadLocalStorageCounterAction extends StoreAction {}

// An action to write the counter value to local storage
class WriteLocalStorageCounterAction extends StoreAction {
  WriteLocalStorageCounterAction({this.context});
  BuildContext context;
}

// An action to indicate the counter has been written to local storage
class WriteLocalStorageCounterSuccessAction extends StoreAction {
  WriteLocalStorageCounterSuccessAction({
    @required this.context,
    @required this.value,
  });
  BuildContext context;
  int value;
}

// An action to indicate the counter has failed to write to local storage
class WriteLocalStorageCounterFailAction extends StoreAction {}
