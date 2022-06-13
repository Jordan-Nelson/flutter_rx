import 'package:flutter_rx_core/flutter_rx_core.dart';
import 'package:test/test.dart';

class IncrementAction extends StoreAction {
  const IncrementAction();
}

class IncrementByAction extends StoreAction {
  final int value;
  const IncrementByAction({required this.value});
}

void main() {
  setUp(() {});
  group('reducer', () {
    test('createReducer', () {
      int _increment(
        int value,
        IncrementAction action,
      ) {
        return value + 1;
      }

      final counterReducer = createReducer<int>([
        On<int, IncrementAction>(_increment),
      ]);
      final action = IncrementAction();
      final initialValue = 0;
      final result = counterReducer(initialValue, action);
      expect(result, initialValue + 1);
    });

    test('createReducer - action with state', () {
      int _incrementBy(
        int value,
        IncrementByAction action,
      ) {
        return value + action.value;
      }

      final counterReducer = createReducer<int>([
        On<int, IncrementByAction>(_incrementBy),
      ]);
      final action = IncrementByAction(value: 10);
      final initialValue = 0;
      final result = counterReducer(initialValue, action);
      expect(result, initialValue + 10);
    });
  });
}
