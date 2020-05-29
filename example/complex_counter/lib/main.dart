import 'package:flutter/material.dart';
import 'package:flutter_rx/flutter_rx.dart';
import 'models/appState.dart';

import 'state/actions.dart';
import 'state/effects.dart';
import 'state/reducer.dart';
import 'state/selectors.dart';

Store<AppState> store = Store(
  initialState: AppState(),
  reducer: reducer,
  effects: storeEffects,
);

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterRx Complex Counter Demo'),
      ),
      body: HomePageBody(),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'The counter value is:',
          ),
          StoreConnector(
            selector: selectCounterSimple,
            builder: (BuildContext context, int value) {
              return Text(
                value.toString(),
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    ChangeCounterByValueAction(value: -5),
                  );
                },
                child: Text('-5'),
              ),
              Container(width: 8),
              RaisedButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    DecrementCounterAction(),
                  );
                },
                child: Text('-1'),
              ),
              Container(width: 8),
              RaisedButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    IncrementCounterAction(),
                  );
                },
                child: Text('+1'),
              ),
              Container(width: 8),
              RaisedButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    ChangeCounterByValueAction(value: 5),
                  );
                },
                child: Text('+5'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(
                        ResetCounterAction(),
                      );
                    },
                    child: Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(
                        WriteLocalStorageCounterAction(context: context),
                      );
                    },
                    child: Text('Write to storage'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(
                        ReadLocalStorageCounterAction(),
                      );
                    },
                    child: Text('Read From Storage'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
