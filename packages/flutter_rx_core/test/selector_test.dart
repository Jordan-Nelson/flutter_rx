import 'package:flutter_rx_core/flutter_rx_core.dart';
import 'package:test/test.dart';

class IncrementAction extends StoreAction {
  const IncrementAction();
}

class IncrementByAction extends StoreAction {
  final int value;
  const IncrementByAction({required this.value});
}

class NestedState {
  const NestedState({required this.value});
  final int value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is NestedState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class AppState extends StoreState {
  const AppState({
    required this.value,
    this.nestedState = const NestedState(value: 1),
  });

  final int value;
  final NestedState nestedState;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AppState &&
        other.value == value &&
        other.nestedState == nestedState;
  }

  @override
  int get hashCode => value.hashCode;
}

void main() {
  group('selectors', () {
    final state1 = AppState(value: 1);
    final state2 = AppState(
      value: 10,
      nestedState: NestedState(value: 10),
    );
    final props = {};

    test('createSelector', () {
      var selectorCallCount = 0;
      final selector = createSelector((AppState state, props) {
        selectorCallCount++;
        return state.value;
      });

      // basic selector
      final value = selector(state1, props);
      expect(value, 1);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector(state1, props);
      expect(value2, 1);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector(state2, props);
      expect(value3, 10);
      expect(selectorCallCount, 2);
    });

    test('createSelector1', () {
      var nestedSelectorCallCount = 0;
      var nestedValueSelectorCallCount = 0;

      final nestedStateSelector = createSelector((AppState state, props) {
        nestedSelectorCallCount++;
        return state.nestedState;
      });

      final nestedValueSelector = createSelector1(
        nestedStateSelector,
        (NestedState state, props) {
          nestedValueSelectorCallCount++;
          return state.value;
        },
      );
      // basic selector
      final value = nestedValueSelector(state1, props);
      expect(value, 1);
      expect(nestedSelectorCallCount, 1);
      expect(nestedValueSelectorCallCount, 1);

      // memoization
      final value2 = nestedValueSelector(state1, props);
      expect(value2, 1);
      expect(nestedSelectorCallCount, 1);
      expect(nestedValueSelectorCallCount, 1);

      // new value
      final value3 = nestedValueSelector(state2, props);
      expect(value3, 10);
      expect(nestedSelectorCallCount, 2);
      expect(nestedValueSelectorCallCount, 2);
    });

    test('createSelector2', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector2 = createSelector2(
        selector,
        selector,
        (int state1, int state2, props) {
          selectorCallCount++;
          return state1 + state2;
        },
      );
      // basic selector
      final value = selector2(state1, props);
      expect(value, 2);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector2(state1, props);
      expect(value2, 2);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector2(state2, props);
      expect(value3, 20);
      expect(selectorCallCount, 2);
    });

    test('createSelector3', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector3 = createSelector3(
        selector,
        selector,
        selector,
        (int state1, int state2, int state3, props) {
          selectorCallCount++;
          return state1 + state2 + state3;
        },
      );
      // basic selector
      final value = selector3(state1, props);
      expect(value, 3);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector3(state1, props);
      expect(value2, 3);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector3(state2, props);
      expect(value3, 30);
      expect(selectorCallCount, 2);
    });

    test('createSelector4', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector4 = createSelector4(
        selector,
        selector,
        selector,
        selector,
        (int state1, int state2, int state3, int state4, props) {
          selectorCallCount++;
          return state1 + state2 + state3 + state4;
        },
      );
      // basic selector
      final value = selector4(state1, props);
      expect(value, 4);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector4(state1, props);
      expect(value2, 4);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector4(state2, props);
      expect(value3, 40);
      expect(selectorCallCount, 2);
    });

    test('createSelector5', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector5 = createSelector5(
        selector,
        selector,
        selector,
        selector,
        selector,
        (int state1, int state2, int state3, int state4, int state5, props) {
          selectorCallCount++;
          return state1 + state2 + state3 + state4 + state5;
        },
      );
      // basic selector
      final value = selector5(state1, props);
      expect(value, 5);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector5(state1, props);
      expect(value2, 5);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector5(state2, props);
      expect(value3, 50);
      expect(selectorCallCount, 2);
    });

    test('createSelector6', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector6 = createSelector6(
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        (
          int state1,
          int state2,
          int state3,
          int state4,
          int state5,
          int state6,
          props,
        ) {
          selectorCallCount++;
          return state1 + state2 + state3 + state4 + state5 + state6;
        },
      );
      // basic selector
      final value = selector6(state1, props);
      expect(value, 6);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector6(state1, props);
      expect(value2, 6);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector6(state2, props);
      expect(value3, 60);
      expect(selectorCallCount, 2);
    });

    test('createSelector7', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector7 = createSelector7(
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        (
          int state1,
          int state2,
          int state3,
          int state4,
          int state5,
          int state6,
          int state7,
          props,
        ) {
          selectorCallCount++;
          return state1 + state2 + state3 + state4 + state5 + state6 + state7;
        },
      );
      // basic selector
      final value = selector7(state1, props);
      expect(value, 7);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector7(state1, props);
      expect(value2, 7);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector7(state2, props);
      expect(value3, 70);
      expect(selectorCallCount, 2);
    });

    test('createSelector8', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector8 = createSelector8(
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        (
          int state1,
          int state2,
          int state3,
          int state4,
          int state5,
          int state6,
          int state7,
          int state8,
          props,
        ) {
          selectorCallCount++;
          return state1 +
              state2 +
              state3 +
              state4 +
              state5 +
              state6 +
              state7 +
              state8;
        },
      );
      // basic selector
      final value = selector8(state1, props);
      expect(value, 8);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector8(state1, props);
      expect(value2, 8);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector8(state2, props);
      expect(value3, 80);
      expect(selectorCallCount, 2);
    });

    test('createSelector9', () {
      var selectorCallCount = 0;

      final selector = createSelector((AppState state, props) {
        return state.value;
      });

      final selector9 = createSelector9(
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        selector,
        (
          int state1,
          int state2,
          int state3,
          int state4,
          int state5,
          int state6,
          int state7,
          int state8,
          int state9,
          props,
        ) {
          selectorCallCount++;
          return state1 +
              state2 +
              state3 +
              state4 +
              state5 +
              state6 +
              state7 +
              state8 +
              state9;
        },
      );
      // basic selector
      final value = selector9(state1, props);
      expect(value, 9);
      expect(selectorCallCount, 1);

      // memoization
      final value2 = selector9(state1, props);
      expect(value2, 9);
      expect(selectorCallCount, 1);

      // new value
      final value3 = selector9(state2, props);
      expect(value3, 90);
      expect(selectorCallCount, 2);
    });
  });
}
