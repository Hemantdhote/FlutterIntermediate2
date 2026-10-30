
import 'package:flutter/material.dart';
import '../../../models/blog_modal.dart';

class BlogCard extends StatelessWidget {
  final BlogModel blog;

  const BlogCard({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            blog.imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 40,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(blog.category),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(height: 8),
                Text(
                  blog.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'By ${blog.authorName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: blog.tags.map((tag) {
                    return Text(
                      '#$tag',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
