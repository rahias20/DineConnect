import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  // instance of authentication
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;
  

  // get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  // sign out user
  Future<void> signUserOut() async {
    return await _auth.signOut();
  }

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  
  // sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try{
      // create user
      UserCredential userCredential = 
          await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password);

      // save user info in a separate collection
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}