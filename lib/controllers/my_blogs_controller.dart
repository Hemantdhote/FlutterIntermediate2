import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/blog_modal.dart';
import '../repositories/blog_repository.dart';

class MyBlogsController extends GetxController {
  final BlogRepository _repository = BlogRepository();

  final blogs = <BlogModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  StreamSubscription<List<BlogModel>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchMyBlogs();
  }

  Future<void> fetchMyBlogs() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      isLoading.value = false;
      errorMessage.value = 'Please login to view your blogs.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    _subscription?.cancel();

    _subscription = _repository.getMyBlogs(user.uid).listen(
      (blogList) {
        blogs.assignAll(blogList);
        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (error) {
        isLoading.value = false;
        errorMessage.value = 'Unable to load your blogs. Please try again.';
      },
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
