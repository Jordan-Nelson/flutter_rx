import 'package:flutter/widgets.dart';
import 'package:flutter_rx_core/flutter_rx_core.dart';
import './rx_stream_builder.dart';

/// Provides a [Store] to all descendants of this Widget. This should
/// generally be a root widget in your app and your app should only
/// conatin one [Store]. Connect to the Store provided by this Widget
/// using `StoreProvider.of<T>(context)`.
class StoreProvider<S extends StoreState> extends InheritedWidget {
  const StoreProvider({
    Key? key,
    required Store<S> store,
    required Widget child,
  })  : _store = store,
        super(key: key, child: child);

  final Store<S> _store;

  static Store<S> of<S extends StoreState>(BuildContext context) {
    StoreProvider<S>? storeProvider =
        context.dependOnInheritedWidgetOfExactType<StoreProvider<S>>();
    assert(storeProvider != null,
        "StoreProvider was null. Make sure that there is a StoreProvider provided.");
    return storeProvider!._store;
  }

  @override
  bool updateShouldNotify(oldWidget) => false;
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
class StoreConnector<S extends StoreState, T> extends StatefulWidget {
  final Selector<S, T> selector;
  final Widget Function(BuildContext, T) builder;
  final void Function()? onInit;
  final void Function(T)? onInitialBuild;
  final dynamic props;
  const StoreConnector({
    super.key,
    required this.selector,
    required this.builder,
    this.props,
    this.onInit,
    this.onInitialBuild,
  });

  @override
  State<StoreConnector<S, T>> createState() => _StoreConnectorState<S, T>();
}

class _StoreConnectorState<S extends StoreState, T>
    extends State<StoreConnector<S, T>> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit!();
    }
    if (widget.onInitialBuild != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        T value = widget.selector(
          StoreProvider.of<S>(context).value,
          widget.props,
        );
        widget.onInitialBuild!(value);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<T> stream = StoreProvider.of<S>(context).select(
      widget.selector,
      widget.props,
    );
    return RxStreamBuilder<T>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return widget.builder(context, snapshot.data as T);
      },
    );
  }
}
