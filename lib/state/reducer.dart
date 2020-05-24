import 'package:my_app/redux/store.dart';

import 'actions.dart';
import 'appState.dart';

Reducer<AppState> reducer = (state, action) {
  return state.copyWith(
    counter: counterReducer(state.counter, action),
  );
};

Reducer<int> counterReducer = createReducer([
  On<int, IncrementCounterAction>(
    (counter, action) => counter + 1,
  ),
  On<int, DecrementCounterAction>(
    (counter, action) => counter - 1,
  ),
  On<int, ChangeCounterByValueAction>(
    (counter, action) => counter + action.value,
  ),
  On<int, ResetCounterAction>(
    (counter, action) => 0,
  ),
  On<int, SetCounterAction>(
    (counter, action) => action.value,
  ),
]);

// Reducer<int> counterReducer = (int counter, StoreAction action) {
//   if (action is IncrementCounterAction) {
//     return counter + 1;
//   }
//   if (action is DecrementCounterAction) {
//     return counter - 1;
//   }
//   if (action is ChangeCounterByValueAction) {
//     return counter + action.value;
//   }
//   if (action is ResetCounterAction) {
//     return 0;
//   }
//   if (action is SetCounterAction) {
//     return action.value;
//   }
//   return counter;
// };
