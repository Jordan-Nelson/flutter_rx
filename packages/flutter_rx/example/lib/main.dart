import 'package:flutter/material.dart';
import 'package:flutter_rx/flutter_rx.dart';
import 'package:rxdart/rxdart.dart';

/// The State of the Application.
///
/// The state must extend [StoreState], and should provide
/// overrides for [==] and [hashCode].
///
/// If a [==] override is not provided, selection memoization
/// will not work, which will lead to unnecessary rebuilds.
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

/// Actions describe unique events and are typically dispatched
/// from widgets or returned from an [Effect].
///
/// Actions must extend [StoreAction].
class IncrementAction extends StoreAction {
  const IncrementAction();
}

/// Actions can optionally contain state.
class IncrementByAction extends StoreAction {
  const IncrementByAction({required this.value});
  final int value;
}

/// Actions can be used to initiate async tasks, such
/// as fetching data from a server.
class FetchCounterValueAction extends StoreAction {
  const FetchCounterValueAction();
}

class FetchCounterValueSuccessAction extends StoreAction {
  const FetchCounterValueSuccessAction({required this.value});
  final int value;
}

/// A reducer is just a pure function that takes in a state and
/// an action, and returns a new state.
///
/// The reducers below are intended to reduce on a specific
/// action, for example [IncrementAction], but reducers can
/// also reduce on any generic [StoreAction].
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

/// [createReducer] takes multiple single purpose reducers and combines them.
///
/// [On] is used to map a specific [StoreAction] to the reducer that
/// should be used when that action is dispatched.
///
/// For example, when [IncrementAction] is received, [incrementCounterReducer]
/// will be used to generate the new state.
final reducer = createReducer<AppState>([
  On<AppState, IncrementAction>(incrementCounterReducer),
  On<AppState, IncrementByAction>(incrementCounterByReducer),
  On<AppState, FetchCounterValueAction>(fetchCounterValueReducer),
  On<AppState, FetchCounterValueSuccessAction>(fetchCounterValueSuccessReducer),
]);

/// Effects handle any and all side effects, such as fetching data from a
/// remote  server.
///
/// Effects receive the stream of actions from the store. Typically
/// this stream is filtered for a specific action.
///
/// Actions are only added to the stream that effects receive after
/// the app's reducers has processed this action and returned a new app state.
/// This guarantees that the state of the store includes mutations from the action
/// being handled by the effect.
///
/// Effects can optionally return one or more actions. These actions
/// will then be dispatched. If the effect returns a list of actions,
/// will ne dispatched in the order of the list.
///
/// Effects should **not** call dispatch to dispatch new actions.
Effect<AppState> onFetchCounter = (
  Stream<StoreAction> actions,
  Store<AppState> store,
) {
  /// RxDart can be useful within effects, but does not need to be used.
  return actions.whereType<FetchCounterValueAction>().flatMap((action) {
    return Stream.fromFuture(fetchCounter()).map((value) {
      return FetchCounterValueSuccessAction(value: value);
    });
  });
};

/// Mock data call.
///
/// In a real app this would be a network call.
Future<int> fetchCounter() {
  return Future.delayed(const Duration(milliseconds: 100)).then((value) => 10);
}

void main() {
  /// Create your store as a final variable in the main function
  /// or inside a State object.
  final store = Store<AppState>(
    /// The initial state of the store.
    initialState: const AppState(counter: 0),

    /// The main reducer.
    ///
    /// This can be a simple pure function, or composed of multiple smaller reducers.
    reducer: reducer,

    /// The list of effects to be registered.
    effects: [onFetchCounter],
  );

  runApp(
    /// The StoreProvider should generally be the top level widget. Only descendants
    /// will have access to the StoreProvider's state.
    StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterRx Counter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),

            /// StoreConnector can be used to access data from the store
            /// using a selector.
            ///
            /// You do not have to use StoreConnect. Data can be streamed from
            /// store using `StoreProvider.of<AppState>(context)`, and the current
            /// snapshot of the store can be read with
            /// `StoreProvider.of<AppState>(context).value`.
            StoreConnector(
              /// The selector maps the apps state to a subset for use in your
              /// widget.
              ///
              /// A simple function could be used in place of createSelector,
              /// but createSelector uses memoization to reduce rebuilds.
              selector: createSelector((AppState state, _) => state.counter),

              /// onInit can be used execute code on the first build. This is
              /// often useful for dispatching an action that fetches data for
              /// view.
              onInit: () {
                StoreProvider.of<AppState>(context).dispatch(
                  const FetchCounterValueAction(),
                );
              },

              /// The builder will only rebuild when when the selector emits
              /// a new value, and memoization ensures that this only happens when
              /// the app state has changed.
              ///
              /// createSelector1, createSelector2, etc. can be used to compose
              /// selectors together. The composed selector will only emit a new value
              /// when one of the input selectors does.
              builder: (BuildContext context, int value) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Use the StoreProvider to get the store and call the dispatch method
          // to dispatch actions.
          StoreProvider.of<AppState>(context).dispatch(
            const IncrementAction(),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
