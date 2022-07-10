import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitdle/constants/strings.dart';
import 'package:fitdle/repository/response.dart';

abstract class AuthRepositoryProtocol {
  Future<Response> createAccount(email, password);
}

class AuthRepository implements AuthRepositoryProtocol {
  @override
  Future<Response> createAccount(email, password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return Failure(custom, e.toString());
    } catch (e) {
      return Failure(custom, e.toString());
    }
    return Success();
  }
}