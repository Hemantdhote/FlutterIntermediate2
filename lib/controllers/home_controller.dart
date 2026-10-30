// import 'package:get/get.dart';
// import '../models/blog_modal.dart';

// class HomeController extends GetxController {
//   final selectedCategory = 'All'.obs;

//   final categories = <String>[
//     'All',
//     'Technology',
//     'Travel',
//     'Lifestyle',
//     'Education',
//   ];

//   final blogs = <BlogModel>[
//     const BlogModel(
//       id: '1',
//       title: 'Getting Started with Flutter',
//       description:
//           'Learn how to build beautiful cross-platform applications using Flutter.',
//       category: 'Technology',
//       tags: ['Flutter', 'Mobile'],
//       imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c',
//       authorName: 'Rahul Sharma',
//     ),
//     const BlogModel(
//       id: '2',
//       title: 'A Weekend in the Mountains',
//       description:
//           'Discover practical tips for planning your next mountain trip.',
//       category: 'Travel',
//       tags: ['Travel', 'Adventure'],
//       imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
//       authorName: 'Priya Verma',
//     ),
//     const BlogModel(
//       id: '3',
//       title: 'Building Better Daily Habits',
//       description:
//           'Simple habits that can help you improve your everyday routine.',
//       category: 'Lifestyle',
//       tags: ['Habits', 'Growth'],
//       imageUrl: 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88',
//       authorName: 'Aman Patel',
//     ),
//     const BlogModel(
//       id: '4',
//       title: 'Why Learning Never Stops',
//       description:
//           'Explore ways to keep learning and growing throughout your career.',
//       category: 'Education',
//       tags: ['Learning', 'Career'],
//       imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b',
//       authorName: 'Neha Singh',
//     ),
//   ].obs;

//   List<BlogModel> get filteredBlogs {
//     if (selectedCategory.value == 'All') {
//       return blogs.toList();
//     }

//     return blogs
//         .where((blog) => blog.category == selectedCategory.value)
//         .toList();
//   }

//   void selectCategory(String category) {
//     selectedCategory.value = category;
//   }
// }

import 'dart:async';

import 'package:get/get.dart';

import '../models/blog_modal.dart';
import '../repositories/blog_repository.dart';

class HomeController extends GetxController {
  final BlogRepository _repository = BlogRepository();

  final selectedCategory = 'All'.obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final blogs = <BlogModel>[].obs;

  StreamSubscription<List<BlogModel>>? _blogSubscription;

  final categories = <String>[
    'All',
    'Technology',
    'Travel',
    'Lifestyle',
    'Education',
  ];

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
