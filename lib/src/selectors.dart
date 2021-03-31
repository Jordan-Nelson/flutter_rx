import './types.dart';
import 'package:memoize/memoize.dart';

/// Create a memoized selector. It will cache the result of the
/// [mapFn] function, and only recompute when the provided selector
/// delivers new results.
Selector<S, T> createSelector<S, T>(
  T Function(S, dynamic) mapFn,
) {
  final memoized = memo2(mapFn);
  return (S state, dynamic props) {
    return memoized(state, props);
  };
}

/// Create a memoized selector starting with one selector. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selector delivers new results.
Selector<S, T> createSelector1<S, R1, T>(
  Selector<S, R1> selector,
  T Function(R1, dynamic) mapFn,
) {
  final memoized = memo2(mapFn);

  return (S state, dynamic props) {
    return memoized(selector(state, props), props);
  };
}

/// Create a memoized selector by combining two selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
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

/// Create a memoized selector by combining three selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
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

/// Create a memoized selector by combining four selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
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

/// Create a memoized selector by combining five selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
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

/// Create a memoized selector by combining six selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
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

/// Create a memoized selector by combining seven selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
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

/// Create a memoized selector by combining eight selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
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

/// Create a memoized selector by combining nine selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
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
