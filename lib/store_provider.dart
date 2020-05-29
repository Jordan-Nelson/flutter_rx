import 'package:flutter/widgets.dart';
import 'package:flutter_rx/rx_stream_builder.dart';
import 'package:flutter_rx/store.dart';
import 'package:flutter_rx/types.dart';

/// Provides a [Store] to all descendants of this Widget. This should
/// generally be a root widget in your app and your app should only
/// conatin one [Store]. Connect to the Store provided by this Widget
/// using `StoreProvider.of<T>(context)`.
class StoreProvider<T> extends InheritedWidget {
  const StoreProvider({
    Key key,
    @required store,
    @required Widget child,
  })  : assert(store != null),
        assert(child != null),
        _store = store,
        super(key: key, child: child);

  final Store<T> _store;

  static Store<T> of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StoreProvider<T>>()
        ?._store;
  }

  @override
  bool updateShouldNotify(_) => false;
}

/// Build a widget based on the state of the [Store].
///
/// This widget is simply a wrapper around a [StreamBuilder].
/// The recommended approach is to use [StreamBuilder] directly,
/// but this widget abstracts away the use of stream for those
/// that prefer that approach
///
/// This widget is helpful in migrating from flutter_redux as it
/// has a similar interface to StoreConnector from flutter_redux
class StoreConnector<State, T> extends StatelessWidget {
  final Selector<State, T> selector;
  final Widget Function(BuildContext, T) builder;
  StoreConnector({@required this.selector, @required this.builder});

  @override
  Widget build(BuildContext context) {
    Stream<T> stream = StoreProvider.of<State>(context).select(selector);
    return RxStreamBuilder<T>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return builder(context, snapshot.data);
      },
    );
  }
}
