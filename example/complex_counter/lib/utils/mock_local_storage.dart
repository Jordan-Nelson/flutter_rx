// Mock local storage class used as an example to show how effects can
// be used to deal with asynchronous actions like network calls or reads
// and writes to a local database
class MockLocalStorage<T> {
  T storage;

  Future<void> write(dynamic data) {
    return Future.delayed(Duration(milliseconds: 300)).then((_) {
      storage = data;
    });
  }

  Future<T> read() {
    return Future.delayed(Duration(milliseconds: 300)).then((_) => storage);
  }
}

MockLocalStorage<int> mockLocalStorage = MockLocalStorage<int>();
