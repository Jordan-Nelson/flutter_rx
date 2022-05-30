import 'package:flutter/material.dart';
import 'package:flutter_rx/flutter_rx.dart';

// One simple action: Increment
// all actions should extends StoreAction
class Increment extends StoreAction {}

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
AppState counterReducer(AppState state, dynamic action) {
  if (action is Increment) {
    return AppState(counter: state.counter + 1);
  }
  return state;
}

class AppState extends StoreState {
  const AppState({@required this.counter});
  final int counter;
}

void main() {
  // Create your store as a final variable in the main function
  // or inside a State object.
  Store<AppState> store = Store<AppState>(
    initialState: AppState(counter: 0),
    reducer: counterReducer,
  );

  runApp(FlutterRxApp(
    store: store,
  ));
}

class FlutterRxApp extends StatelessWidget {
  final Store<AppState> store;

  FlutterRxApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    //
    // StoreProvider is just an InheritedWidget
    // This is the simplest way to provide your store to all ancestors,
    // but you are free to use other means of doing so if it better suits your needs
    return StoreProvider<AppState>(
      // Pass the store to the StoreProvider so that any ancestor will have access.
      store: store,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterRx Counter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have pushed the button this many times:',
            ),
            // The State is exposed as a stream which allows you to use
            // widgets you are already familiar with like StreamBuilder
            // to listen to the application state
            //
            // Every time the button is tapped, an action is dispatched and
            // run through the reducer. After the reducer updates the state,
            // a new value is added to the state causing the Widget to
            // automatically rebuilt with the latest count.
            StreamBuilder(
              // Use the StoreProvider to get the store pass in the state
              stream: StoreProvider.of<AppState>(context)
                  .state
                  .map((state) => state.counter),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text(
                  snapshot.hasData ? snapshot.data.toString() : '',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Use the StoreProvider to get the store and call the dispatch methed
        // with the increment action
        onPressed: () => StoreProvider.of<AppState>(context).dispatch(
          Increment(),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
