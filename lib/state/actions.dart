import 'package:flutter/foundation.dart';
import 'package:my_app/redux/store.dart';

class IncrementCounterAction extends StoreAction {}

class DecrementCounterAction extends StoreAction {}

class ResetCounterAction extends StoreAction {}

class SetCounterAction extends StoreAction {
  SetCounterAction({@required this.value});
  int value;
}

class DelayedIncrementCounterAction extends StoreAction {}

class ReadLocalStorageCounterAction extends StoreAction {}

class WriteLocalStorageCounterAction extends StoreAction {
  WriteLocalStorageCounterAction({@required this.value});
  int value;
}

class WriteLocalStorageCounterSuccessAction extends StoreAction {}

class WriteLocalStorageCounterFailAction extends StoreAction {}

class ChangeCounterByValueAction extends StoreAction {
  ChangeCounterByValueAction({@required this.value});
  int value;
}
