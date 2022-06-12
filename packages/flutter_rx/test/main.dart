import 'package:flutter/material.dart';
import 'package:flutter_rx/flutter_rx.dart';
import 'package:flutter_test/flutter_test.dart';

// app state
class AppState extends StoreState {
  const AppState({required this.counter});
  final int counter;

  AppState copyWith({int? counter}) {
    return AppState(counter: counter ?? this.counter);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AppState && other.counter == counter;
  }

  @override
  int get hashCode => counter.hashCode;
}

// actions
class IncrementAction extends StoreAction {
  const IncrementAction();
}

// reducers
AppState _incrementCounter(
  AppState state,
  IncrementAction action,
) {
  return state.copyWith(counter: state.counter + 1);
}

final reducer = createReducer<AppState>([
  On<AppState, IncrementAction>(_incrementCounter),
]);

// selectors
Selector<AppState, int> selector = createSelector(
  (AppState state, props) {
    return state.counter;
  },
);

final store = Store<AppState>(
  initialState: const AppState(counter: 0),
  reducer: reducer,
);

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: AppHome(),
      ),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StoreConnector(
          selector: selector,
          builder: (BuildContext context, int value) {
            return Text('Counter value is: $value');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          StoreProvider.of<AppState>(context).dispatch(const IncrementAction());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> waitForActionToPropogate() => Future.delayed(Duration.zero);

void main() {
  group('Store', () {
    testWidgets('increment counter', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const AppRoot());

      // Verify that our counter starts at 0.
      expect(find.text('Counter value is: 0'), findsOneWidget);
      expect(find.text('Counter value is: 1'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('Counter value is: 0'), findsNothing);
      expect(find.text('Counter value is: 1'), findsOneWidget);
    });
  });
}
