class ApiService {
  // Example method
  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    return 'Fetched data';
  }
}
