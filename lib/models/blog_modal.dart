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
    final rawDate = map['createdAt'];
    DateTime? parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    }

    return BlogModel(
      id: documentId,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      tags: (map['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      imageUrl: map['imageUrl'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      createdAt: parsedDate,
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
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
