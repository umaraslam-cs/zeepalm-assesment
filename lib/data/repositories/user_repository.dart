import '../datasources/local_data_source.dart';

class UserRepository {
  final LocalDataSource localDataSource;

  UserRepository(this.localDataSource);

  String getUserData() {
    return localDataSource.getLocalData();
  }
}
