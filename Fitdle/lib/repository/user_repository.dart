import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/base_repository.dart';
import 'package:fitdle/models/user.dart';

abstract class UserRepositoryProtocol {
  Future<Object> createUser();
  Future<Object> fetchUser(email);
}

class UserRepository extends BaseRepository implements UserRepositoryProtocol {
  final User user = User();

  @override
  Future<Object> createUser() async {
    var res = await post("/users/create", user.toJson());
    return res;
  }
  
  @override
  Future<Object> fetchUser(email) async {
    var res = await fetch("/users/", email);
    if(res is Success && res.data != null) {
      var json = res.data as Map<String, dynamic>;
      user.update(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        birthDate: json["birthDate"],
        numPoints: json["numPoints"]
      );
    }
    return res; // let VM handle what UI to show for success/fail
  }
}