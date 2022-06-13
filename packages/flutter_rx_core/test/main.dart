import 'package:test/test.dart';

import './reducer_test.dart' as reducer_test;
import './selector_test.dart' as selector_test;
import './store_test.dart' as store_test;

void main() {
  group('flutter_redux_core', () {
    reducer_test.main();
    selector_test.main();
    store_test.main();
  });
}
