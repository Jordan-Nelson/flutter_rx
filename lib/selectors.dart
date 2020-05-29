import 'package:flutter_rx/types.dart';
import 'package:memoize/memoize.dart';

/// Create a memoized selector. It will cache the result of the
/// [mapFn] function, and only recompute when the provided selector
/// delivers new results.
Selector<S, T> createSelector<S, T>(
  T Function(S) mapFn, {
  T Function(S) Function(T Function(S)) memoize,
}) {
  final memoized = (memoize ?? memo1)(mapFn);
  return (S state) {
    return memoized(state);
  };
}

/// Create a memoized selector starting with one selector. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selector delivers new results.
Selector<S, T> createSelector1<S, R1, T>(
  Selector<S, R1> selector,
  T Function(R1) mapFn, {
  T Function(R1) Function(T Function(R1)) memoize,
}) {
  final memoized = (memoize ?? memo1)(mapFn);

  return (S state) {
    return memoized(selector(state));
  };
}

/// Create a memoized selector by combining two selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
Selector<S, T> createSelector2<S, R1, R2, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  T Function(R1, R2) mapFn, {
  T Function(R1, R2) Function(T Function(R1, R2)) memoize,
}) {
  final memoized = (memoize ?? memo2)(mapFn);

  return (S state) {
    return memoized(selector1(state), selector2(state));
  };
}

/// Create a memoized selector by combining three selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
Selector<S, T> createSelector3<S, R1, R2, R3, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  T Function(R1, R2, R3) mapFn, {
  T Function(R1, R2, R3) Function(T Function(R1, R2, R3)) memoize,
}) {
  final memoized = (memoize ?? memo3)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
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
  T Function(R1, R2, R3, R4) mapFn, {
  T Function(R1, R2, R3, R4) Function(T Function(R1, R2, R3, R4)) memoize,
}) {
  final memoized = (memoize ?? memo4)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
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
  T Function(R1, R2, R3, R4, R5) mapFn, {
  T Function(R1, R2, R3, R4, R5) Function(T Function(R1, R2, R3, R4, R5))
      memoize,
}) {
  final memoized = (memoize ?? memo5)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
      selector5(state),
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
  T Function(R1, R2, R3, R4, R5, R6) mapFn, {
  T Function(R1, R2, R3, R4, R5, R6) Function(
          T Function(R1, R2, R3, R4, R5, R6))
      memoize,
}) {
  final memoized = (memoize ?? memo6)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
      selector5(state),
      selector6(state),
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
  T Function(R1, R2, R3, R4, R5, R6, R7) mapFn, {
  T Function(R1, R2, R3, R4, R5, R6, R7) Function(
          T Function(R1, R2, R3, R4, R5, R6, R7))
      memoize,
}) {
  final memoized = (memoize ?? memo7)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
      selector5(state),
      selector6(state),
      selector7(state),
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
  T Function(R1, R2, R3, R4, R5, R6, R7, R8) mapFn, {
  T Function(R1, R2, R3, R4, R5, R6, R7, R8) Function(
          T Function(R1, R2, R3, R4, R5, R6, R7, R8))
      memoize,
}) {
  final memoized = (memoize ?? memo8)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
      selector5(state),
      selector6(state),
      selector7(state),
      selector8(state),
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
  T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9) mapFn, {
  T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9) Function(
          T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9))
      memoize,
}) {
  final memoized = (memoize ?? memo9)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
      selector5(state),
      selector6(state),
      selector7(state),
      selector8(state),
      selector9(state),
    );
  };
}

/// Create a memoized selector by combining ten selectors. It will cache the
/// result of the [mapFn] function, and only recompute when the provided
/// selectors deliver new results.
///
/// A complete example can be seen as part of the [Selector] documentation.
Selector<S, T> createSelector10<S, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, T>(
  Selector<S, R1> selector1,
  Selector<S, R2> selector2,
  Selector<S, R3> selector3,
  Selector<S, R4> selector4,
  Selector<S, R5> selector5,
  Selector<S, R6> selector6,
  Selector<S, R7> selector7,
  Selector<S, R8> selector8,
  Selector<S, R9> selector9,
  Selector<S, R10> selector10,
  T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9, R10) mapFn, {
  T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9, R10) Function(
          T Function(R1, R2, R3, R4, R5, R6, R7, R8, R9, R10))
      memoize,
}) {
  final memoized = (memoize ?? memo10)(mapFn);

  return (S state) {
    return memoized(
      selector1(state),
      selector2(state),
      selector3(state),
      selector4(state),
      selector5(state),
      selector6(state),
      selector7(state),
      selector8(state),
      selector9(state),
      selector10(state),
    );
  };
}
