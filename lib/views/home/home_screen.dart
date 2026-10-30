import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../app/routes/app_routes.dart';
import 'widgets/blog_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Blog App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.myBlogs),
            child: const Text('My Blogs'),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => Get.find<AuthController>().logout(),
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
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
                      onPressed: controller.fetchBlogs,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final blogs = controller.filteredBlogs;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Discover Stories',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore ideas, experiences, and knowledge from our community.',
                ),
                const SizedBox(height: 24),

                SizedBox(
                  height: 45,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];

                      return Obx(() {
                        final isSelected =
                            controller.selectedCategory.value == category;

                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            controller.selectCategory(category);
                          },
                        );
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '${blogs.length} blog posts',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                if (blogs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No blogs found in this category.'),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      final crossAxisCount = width >= 900
                          ? 3
                          : width >= 600
                          ? 2
                          : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: blogs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 410,
                        ),
                        itemBuilder: (context, index) {
                          return BlogCard(blog: blogs[index]);
                        },
                      );
                    },
                  ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.createBlog);
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Blog'),
      ),
    );
  }
}
