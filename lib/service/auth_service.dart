import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1️⃣ Create auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      // 2️⃣ Save user to Firestore
      final appUser = AppUser(uid: user.uid, name: name, email: email);

      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Signup failed';
    }
  }

  // LOGIN
  Future<User?> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  // GET USER DATA
  Future<AppUser?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
