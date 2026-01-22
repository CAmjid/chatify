import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => auth.currentUser;

  Future<UserCredential> signinData(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('SignIn Error: ${e.code}');
    }
  }

  Future<UserCredential> signupData(
    String name,
    String email,
    String password,
  ) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(credential.user!.uid)
        .set({
          'uid': credential.user!.uid,
          'name': name.trim(),
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
    return credential;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
