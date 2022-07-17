import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitdle/repository/api_response.dart';

abstract class AuthRepositoryProtocol {
  Future<Object> createAccount(email, password);
  Future<Object> login(email, password);
  Future<void> logout();
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
      return Failure(e.message);
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
       return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
    return Success();
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

}