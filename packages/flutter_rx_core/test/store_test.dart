import 'package:flutter_rx_core/flutter_rx_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

// mock server
int counter = 10;
Future<int> fetchCounter() {
  return Future.delayed(Duration(milliseconds: 100)).then((value) => counter);
}

// app state
class AppState extends StoreState {
  const AppState({required this.counter, this.isLoading = false});
  final int counter;
  final bool isLoading;

  AppState copyWith({int? counter, bool? isLoading}) {
    return AppState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AppState &&
        other.counter == counter &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => counter.hashCode ^ isLoading.hashCode;
}

// actions
class IncrementAction extends StoreAction {
  const IncrementAction();
}

class IncrementByAction extends StoreAction {
  const IncrementByAction({required this.value});
  final int value;
}

class FetchCounterValueAction extends StoreAction {
  const FetchCounterValueAction();
}

class FetchCounterValueSuccessAction extends StoreAction {
  const FetchCounterValueSuccessAction({required this.value});
  final int value;
}

// reducers
AppState incrementCounterReducer(
  AppState state,
  IncrementAction action,
) {
  return state.copyWith(counter: state.counter + 1);
}

AppState incrementCounterByReducer(
  AppState state,
  IncrementByAction action,
) {
  return state.copyWith(counter: state.counter + action.value);
}

AppState fetchCounterValueReducer(
  AppState state,
  FetchCounterValueAction action,
) {
  return state.copyWith(
    isLoading: true,
  );
}

AppState fetchCounterValueSuccessReducer(
  AppState state,
  FetchCounterValueSuccessAction action,
) {
  return state.copyWith(
    counter: action.value,
    isLoading: false,
  );
}

final reducer = createReducer<AppState>([
  On<AppState, IncrementAction>(incrementCounterReducer),
  On<AppState, IncrementByAction>(incrementCounterByReducer),
  On<AppState, FetchCounterValueAction>(fetchCounterValueReducer),
  On<AppState, FetchCounterValueSuccessAction>(fetchCounterValueSuccessReducer),
]);

// effects
Effect<AppState> onFetchCounter = (
  Stream<StoreAction> actions,
  Store<AppState> store,
) {
  return actions.whereType<FetchCounterValueAction>().flatMap((action) {
    return Stream.fromFuture(fetchCounter()).map((value) {
      return FetchCounterValueSuccessAction(value: value);
    });
  });
};

Future<void> waitForActionToPropagate() => Future.delayed(Duration.zero);
Future<void> waitForAsyncTask() => Future.delayed(Duration(milliseconds: 110));

void main() {
  late Store<AppState> store;
  setUp(() {
    store = Store<AppState>(
      initialState: AppState(counter: 0, isLoading: false),
      reducer: reducer,
      effects: [onFetchCounter],
    );
  });
  group('store tests', () {
    test('increment counter', () async {
      expect(store.value, AppState(counter: 0, isLoading: false));

      store.dispatch(IncrementAction());

      await waitForActionToPropagate();

      expect(store.value, AppState(counter: 1, isLoading: false));
    });

    test('increment counter by 10', () async {
      expect(store.value, AppState(counter: 0, isLoading: false));

      store.dispatch(IncrementByAction(value: 10));

      await waitForActionToPropagate();

      expect(store.value, AppState(counter: 10, isLoading: false));
    });

    test('fetch counter', () async {
      expect(store.value, AppState(counter: 0, isLoading: false));

      store.dispatch(FetchCounterValueAction());

      await waitForActionToPropagate();

      expect(store.value, AppState(counter: 0, isLoading: true));

      await waitForAsyncTask();

      expect(store.value, AppState(counter: 10, isLoading: false));
    });
  });
}
