class MockLocalStorage {
  dynamic storage;

  Future write(dynamic data) {
    return Future.delayed(Duration(milliseconds: 300)).then((_) {
      storage = data;
    });
  }

  Future read() {
    return Future.delayed(Duration(milliseconds: 300)).then((_) => storage);
  }
}

MockLocalStorage mockLocalStorage = MockLocalStorage();
