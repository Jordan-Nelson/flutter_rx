import './types.dart';
import 'package:memoize/memoize.dart';

/// Create a selector from the App's State.
///
/// Creates a memoized selector. The result of the function will only
/// be recomputed when the provided state or props change.
Selector<S, T> createSelector<S, T>(
  T Function(S, dynamic) mapFn,
) {
  final memoized = memo2(mapFn);
  return (S state, dynamic props) {
    return memoized(state, props);
  };
}

/// Create a selector composed from one other selector.
///
/// Creates a memoized selector. The result of the function will only
/// be recomputed when the composed selector returns a new value.
Selector<S, T> createSelector1<S, R1, T>(
  Selector<S, R1> selector,
  T Function(R1, dynamic) mapFn,
) {
  final memoized = memo2(mapFn);

  return (S state, dynamic props) {
    return memoized(selector(state, props), props);
  };
}

/// Create a selector composed from two other selectors.
///
/// {@template flutter_rx_core.selectors.memoize}
/// Creates a memoized selector. The result of the function will only
/// be recomputed when one of the composed selectors returns a new value.
/// {@endtemplate}
Selector<S, T> createSelector2<S, R1, R2, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  T Function(R1, R2, dynamic) mapFn,
) {
  final memoized = memo3(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      props,
    );
  };
}

/// Create a selector composed from three other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector3<S, R1, R2, R3, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  T Function(R1, R2, R3, dynamic) mapFn,
) {
  final memoized = memo4(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      props,
    );
  };
}

/// Create a selector composed from four other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector4<S, R1, R2, R3, R4, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  T Function(R1, R2, R3, R4, dynamic) mapFn,
) {
  final memoized = memo5(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      selector4(state, props),
      props,
    );
  };
}

/// Create a selector composed from five other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector5<S, R1, R2, R3, R4, R5, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  Selector<S, R5> selector5,
  T Function(R1, R2, R3, R4, R5, dynamic) mapFn,
) {
  final memoized = memo6(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      selector4(state, props),
      selector5(state, props),
      props,
    );
  };
}

/// Create a selector composed from six other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector6<S, R1, R2, R3, R4, R5, R6, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  Selector<S, R5> selector5,
  Selector<S, R6> selector6,
  T Function(R1, R2, R3, R4, R5, R6, dynamic) mapFn,
) {
  final memoized = memo7(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      selector4(state, props),
      selector5(state, props),
      selector6(state, props),
      props,
    );
  };
}

/// Create a selector composed from seven other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector7<S, R1, R2, R3, R4, R5, R6, R7, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  Selector<S, R5> selector5,
  Selector<S, R6> selector6,
  Selector<S, R7> selector7,
  T Function(R1, R2, R3, R4, R5, R6, R7, dynamic) mapFn,
) {
  final memoized = memo8(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      selector4(state, props),
      selector5(state, props),
      selector6(state, props),
      selector7(state, props),
      props,
    );
  };
}

/// Create a selector composed from eight other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector8<S, R1, R2, R3, R4, R5, R6, R7, R8, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  Selector<S, R5> selector5,
  Selector<S, R6> selector6,
  Selector<S, R7> selector7,
  Selector<S, R8> selector8,
  T Function(R1, R2, R3, R4, R5, R6, R7, R8, dynamic) mapFn,
) {
  final memoized = memo9(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      selector4(state, props),
      selector5(state, props),
      selector6(state, props),
      selector7(state, props),
      selector8(state, props),
      props,
    );
  };
}

/// Create a selector composed from nine other selectors.
///
/// {@macro flutter_rx_core.selectors.memoize}
Selector<S, T> createSelector9<S, R1, R2, R3, R4, R5, R6, R7, R8, R9, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  Selector<S, R5> selector5,
  Selector<S, R6> selector6,
  Selector<S, R7> selector7,
  Selector<S, R8> selector8,
  Selector<S, R9> selector9,
  T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9, dynamic) mapFn,
) {
  final memoized = memo10(mapFn);

  return (S state, dynamic props) {
    return memoized(
      selector1(state, props),
      selector2(state, props),
      selector3(state, props),
      selector4(state, props),
      selector5(state, props),
      selector6(state, props),
      selector7(state, props),
      selector8(state, props),
      selector9(state, props),
      props,
    );
  };
}
