import 'actions.dart';
import 'appState.dart';

AppState reducer(AppState state, action) {
  return state.copyWith(
    counter: counterReducer(state.counter, action),
  );
}

int counterReducer(int counter, action) {
  if (action is IncrementCounterAction) {
    return counter + 1;
  }
  if (action is DecrementCounterAction) {
    return counter - 1;
  }
  if (action is ChangeCounterByValueAction) {
    return counter + action.value;
  }
  if (action is ResetCounterAction) {
    return 0;
  }
  if (action is SetCounterAction) {
    return action.value;
  }
  return counter;
}
