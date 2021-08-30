import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework2/model/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // create user obj from FirebaseUser
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // return a stream of firebase auth changes
  Stream<AppUser?> get authChanges {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }

  // TODO anon sign in
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
  // TODO email pass login
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firUser = result.user;
      // TODO Let the app know which user is logged in, get user id and connect it with user at firestore
      // Get everything for that user. Save the user in local storage

      return _userFromFirebaseUser(firUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // TODO register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firUser = result.user;
      // Create user in Firebase Storage

      DocumentReference firUserDoc = _userCollection.doc(firUser!.uid);
      // TODO ADD FIELDS FOR USER   firUserDoc.set  deviceToken , createdJobs, enrolledJobs, name (email), surname (if provided later), username (email)
      await updateUserData(firUserDoc.id, email, 'unknown');
      return _userFromFirebaseUser(firUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // TODO sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future updateUserData(String uid, String name, String surname) async {
    return await _userCollection.doc(uid).set({
      'name': name,
      'surname': surname
    });
  }

}

class FirebaseService {

  // collection Ref
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection('jobCategories');



}