import 'dart:async';

import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../models/blog_modal.dart';
import '../repositories/blog_repository.dart';

class HomeController extends GetxController {
  final BlogRepository _repository = BlogRepository();

  final selectedCategory = 'All'.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final blogs = <BlogModel>[].obs;

  StreamSubscription<List<BlogModel>>? _blogSubscription;

  List<String> get categories => AppConstants.allCategories;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  void fetchBlogs() {
    isLoading.value = true;
    errorMessage.value = '';

    _blogSubscription?.cancel();

    _blogSubscription = _repository.getAllBlogs().listen(
      (blogList) {
        blogs.assignAll(blogList);
        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (error) {
        errorMessage.value = 'Unable to load blogs. Please try again.';
        isLoading.value = false;
      },
    );
  }

  List<BlogModel> get filteredBlogs {
    if (selectedCategory.value == 'All') {
      return blogs.toList();
    }

    return blogs
        .where((blog) => blog.category == selectedCategory.value)
        .toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  @override
  void onClose() {
    _blogSubscription?.cancel();
    super.onClose();
  }
}
