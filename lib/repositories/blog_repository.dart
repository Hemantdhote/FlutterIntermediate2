import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/blog_modal.dart';

class BlogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _blogs =>
      _firestore.collection('blogs');

  Stream<List<BlogModel>> getAllBlogs() {
    return _blogs.snapshots().map((snapshot) {
      final list = snapshot.docs.map((document) {
        return BlogModel.fromMap(document.data(), document.id);
      }).toList();

      list.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return list;
    });
  }

  Future<void> createBlog(BlogModel blog) async {
    await _blogs.add(blog.toMap());
  }

  Stream<List<BlogModel>> getMyBlogs(String userId) {
    return _blogs
        .where('authorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((document) {
            return BlogModel.fromMap(document.data(), document.id);
          }).toList();

          list.sort((a, b) {
            final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });

          return list;
        });
  }
}
