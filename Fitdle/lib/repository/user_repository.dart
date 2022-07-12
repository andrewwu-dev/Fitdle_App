import 'package:fitdle/repository/base_repository.dart';
import 'package:fitdle/models/user.dart';

abstract class UserRepositoryProtocol {
  Future<Object> createUser();
}

class UserRepository extends BaseRepository implements UserRepositoryProtocol {
  final User user = User();

  @override
  Future<Object> createUser() async {
    var res = await post("/users/create", user.toJson());
    print(res);
    return res;
  }
}