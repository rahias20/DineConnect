import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of FirebaseAuth used for user authentication.
  final FirebaseAuth _auth;
  // Instance of FirebaseFirestore used for data storage.
  final FirebaseFirestore _firestore;

  // Constructor with optional parameters for FirebaseAuth and FirebaseFirestore.
  // This allows for dependency injection, useful during testing.
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Method to retrieve the currently signed-in user.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Method to sign out the current user.
  Future<void> signUserOut() async {
    return await _auth.signOut();
  }

  // Method to sign in a user using email and password.
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Method to sign up a new user with email and password.
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      // create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
