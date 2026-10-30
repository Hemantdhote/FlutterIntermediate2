
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/create_blog_controller.dart';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final _formKey = GlobalKey<FormState>();

  late final CreateBlogController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CreateBlogController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Share Your Story',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Blog Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter blog title';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Category
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedCategory.value,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedCategory.value = value;
                        }
                      },
                    );
                  }),

                  const SizedBox(height: 16),

                  // Tags
                  TextFormField(
                    controller: controller.tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags',
                      hintText: 'Flutter, Dart, Firebase',
                      helperText: 'Separate tags using commas',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Image URL
                  TextFormField(
                    controller: controller.imageUrlController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'https://example.com/image.jpg',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final url = value?.trim() ?? '';
                      if (url.isEmpty) {
                        return 'Please enter image URL';
                      }

                      final uri = Uri.tryParse(url);
                      if (uri == null ||
                          !uri.hasAuthority ||
                          !['http', 'https'].contains(uri.scheme)) {
                        return 'Please enter a valid HTTP/HTTPS URL';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Publish button
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                controller.createBlog();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text('Publish Blog'),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
