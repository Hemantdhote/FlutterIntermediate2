import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_modal.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<bool> profileExists(String uid) async {
    final document = await _users.doc(uid).get();
    return document.exists;
  }

  Future<void> createProfile(UserModel user) async {
    await _users.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getProfile(String uid) async {
    final document = await _users.doc(uid).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return UserModel.fromMap(document.data()!, document.id);
  }
}
