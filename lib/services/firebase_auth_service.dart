import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isGoogleInitialized = false;

  User? get currentUser => _auth.currentUser;

  Future<void> _ensureGoogleInitialized() async {
    if (_isGoogleInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '140113081652-e39f3m9875s0b9ai5qt733v0p9ts6sbm.apps.googleusercontent.com',
    );
    _isGoogleInitialized = true;
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    final GoogleSignInAccount? account =
        await GoogleSignIn.instance.authenticate();
    if (account == null) return null;

    final GoogleSignInAuthentication auth = account.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      debugPrint('Google SignoUt Error: $e');
    }
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
