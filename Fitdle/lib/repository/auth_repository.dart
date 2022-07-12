import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitdle/repository/api_response.dart';

abstract class AuthRepositoryProtocol {
  Future<Object> createAccount(email, password);
  Future<Object> login(email, password);
}

class AuthRepository implements AuthRepositoryProtocol {
  @override
  Future<Object> createAccount(email, password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return Failure(e.toString());
    } catch (e) {
      return Failure(e.toString());
    }
    return Success();
  }

  @override
  Future<Object> login(email, password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      return Failure(e.toString());
    }
    print("LOGINED ");
    return Success();
  }

}