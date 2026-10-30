
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final String authorId;
  final String authorName;
  final DateTime? createdAt;

  const BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.authorId,
    required this.authorName,
    this.createdAt,
  });

  factory BlogModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return BlogModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'tags': tags,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
