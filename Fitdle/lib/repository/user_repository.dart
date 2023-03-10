import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/base_repository.dart';
import 'package:fitdle/models/user.dart';

abstract class UserRepositoryProtocol {
  void clearUser();
  void updateUser(user);
  Future<Object> createUser();
  Future<Object> fetchUser(email);
  Future<Object> fetchExcercises(timeRange);
  Future<Object> fetchEarnings(start, end);
}

class UserRepository extends BaseRepository implements UserRepositoryProtocol {
  final User user = User();

  @override
  void clearUser() {
    user.clear();
  }

  @override
  void updateUser(json) {
    user.update(
        id: json["userID"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        birthDate: json["birthDate"],
        numPoints: json["numPoints"]);
    bodyWeight:
    json["bodyWeight"];
  }

  @override
  Future<Object> createUser() async {
    var res = await post("/users/create", user.toJson());
    return res;
  }

  @override
  Future<Object> fetchUser(email) async {
    var queryParam = {"email": email};
    var res = await fetch("/users/", queryParam);
    if (res is Success && (res.data != null || res.data != "")) {
      var json = res.data as Map<String, dynamic>;
      user.update(
          id: json["userID"],
          email: json["email"],
          firstName: json["firstName"],
          lastName: json["lastName"],
          birthDate: json["birthDate"],
          numPoints: json["numPoints"]);
      bodyWeight:
      json["bodyWeight"];
    }
    return res;
  }

  @override
  Future<Object> fetchExcercises(start, [end]) async {
    var queryParam = {"start": start};
    if (end != Null) {
      queryParam["end"] = end;
    }
    var res = await fetch("/users/exercises/${user.id}", queryParam);
    return res;
  }

  @override
  Future<Object> fetchEarnings(start, end) async {
    var endpoint = "/users/earnings/${user.id}";
    var params = {"start": start, "end": end};
    var res = await fetch(endpoint, params);
    return res;
  }
}
