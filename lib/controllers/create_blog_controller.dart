
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';

import '../models/blog_modal.dart';
import '../repositories/blog_repository.dart';

class CreateBlogController extends GetxController {
  final BlogRepository _repository = BlogRepository();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();
  final imageUrlController = TextEditingController();

  final selectedCategory = 'Technology'.obs;
  final isLoading = false.obs;

  final categories = [
    'Technology',
    'Travel',
    'Lifestyle',
    'Education',
  ];

  Future<void> createBlog() async {
    if (isLoading.value) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar('Login Required', 'Please login first.');
      return;
    }

    isLoading.value = true;

    try {
      final blog = BlogModel(
        id: '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory.value,
        tags: tagsController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList(),
        imageUrl: imageUrlController.text.trim(),
        authorId: user.uid,
        authorName: user.displayName ??
            user.email?.split('@').first ??
            'Anonymous',
      );

      await _repository.createBlog(blog);

      Get.snackbar(
        'Success',
        'Your blog has been published!',
      );

      // Get.back();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to publish blog. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }
}
