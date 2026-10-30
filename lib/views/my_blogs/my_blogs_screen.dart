import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/my_blogs_controller.dart';
import '../../app/routes/app_routes.dart';
import '../home/widgets/blog_card.dart';

class MyBlogsScreen extends GetView<MyBlogsController> {
  const MyBlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Blogs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.createBlog),
        icon: const Icon(Icons.add),
        label: const Text('Create Blog'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(controller.errorMessage.value),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.fetchMyBlogs,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (controller.blogs.isEmpty) {
              return const Center(
                child: Text('You have not published any blogs yet.'),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final crossAxisCount = width >= 900
                    ? 3
                    : width >= 600
                        ? 2
                        : 1;

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.blogs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 410,
                  ),
                  itemBuilder: (context, index) {
                    return BlogCard(blog: controller.blogs[index]);
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}