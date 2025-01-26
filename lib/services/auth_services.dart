import 'package:chatgpt/database/database.dart';
import 'package:chatgpt/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  /// Signs in a user using email and password
  ///
  /// [emailAddress]: The user's email.
  /// [password]: The user's password.
  /// Returns a success message or error string based on the result.
  static Future<String> signInWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.');
      }
      return "error: ${e.code}";
    }
  }


  /// Creates a new user with email, password, and display name
  ///
  /// [emailAddress]: The user's email.
  /// [password]: The user's password.
  /// [firstName]: The user's first name.
  /// [lastName]: The user's last name.
  /// Returns a success message or error string based on the result.
  static Future<String> createUserWithEmailAndPassword(String emailAddress,
      String password, String firstName, String lastName) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await credential.user?.updateDisplayName("$firstName $lastName");
      await credential.user?.reload();

      print(credential.user?.displayName);

      UserModel data = UserModel.fromJson({
        "name": "$firstName $lastName",
        "email": credential.user?.email,
        "userId": credential.user?.uid,
      });
      MongoDB.insertUser(data);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
      return "error: ${e.code}";
    } catch (e) {
      print(e);
      return "Unknown error";
    }
  }
}
