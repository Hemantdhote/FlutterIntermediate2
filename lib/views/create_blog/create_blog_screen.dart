import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/create_blog_controller.dart';
import '../../utils/validators.dart';
import '../../theme/app_colors.dart';

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

  void _showCategoryPicker(BuildContext context) {
    // Unfocus any open soft keyboard first so the sheet appears cleanly
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ...controller.categories.map((category) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == category;

                    return ListTile(
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      title: Text(
                        category,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? AppColors.primary : Colors.black87,
                        ),
                      ),
                      onTap: () {
                        controller.selectedCategory.value = category;
                        Navigator.pop(bottomSheetContext);
                      },
                    );
                  });
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
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
                  const SizedBox(height: 8),
                  const Text(
                    'Publish an article for the community to read.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Blog Title',
                      hintText: 'Enter a catchy title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => Validators.required(val, 'blog title'),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Description / Content',
                      hintText: 'Write your story here...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        Validators.required(val, 'blog description'),
                  ),

                  const SizedBox(height: 16),

                  // Category Picker
                  Obx(() {
                    return InkWell(
                      onTap: () => _showCategoryPicker(context),
                      borderRadius: BorderRadius.circular(4),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                        ),
                        child: Text(
                          controller.selectedCategory.value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Tags
                  TextFormField(
                    controller: controller.tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags (Optional)',
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
                      labelText: 'Cover Image URL',
                      hintText: 'https://images.unsplash.com/...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        Validators.url(val, fieldName: 'cover image URL'),
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
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Publish Blog',
                              style: TextStyle(fontSize: 16),
                            ),
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
