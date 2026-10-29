
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
    await _users.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getProfile(String uid) async {
    final document = await _users.doc(uid).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data()!;

    return UserModel(
      uid: data['uid'] as String? ?? document.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      provider: data['provider'] as String? ?? 'email',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
