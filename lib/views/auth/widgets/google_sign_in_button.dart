import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            return OutlinedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.signInWithGoogle,
              icon: Image.network(
                'https://scontent.fbho3-1.fna.fbcdn.net/v/t39.30808-6/461318528_1057199622436993_2429427774568686653_n.jpg?stp=dst-jpg_tt6&cstp=mx1080x1080&ctp=s1080x1080&_nc_cat=107&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=a5f93a&_nc_ohc=JpC-RTjH3t8Q7kNvwGkbi1r&_nc_oc=AdrWvsu6vQNHCgqBaTR3x4nzkhXmRKc5ovHMW_nn--ZPFRBf1kI8oQLxHDcLF5uayqIZfEYQLt8FXsDU-UvU42zT&_nc_zt=23&_nc_ht=scontent.fbho3-1.fna&_nc_gid=2Reoz7p5q7P40F4kT93unw&_nc_ss=78289&oh=00_AQTk2a0mi9zO6a_Vxbjd--CQVdM8NEa-nXo9Gst7HSgwTA&oe=6AEE1016',
                height: 20,
                width: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.g_mobiledata, size: 24),
              ),
              label: const Text(
                'Continue with Google',
                style: TextStyle(fontSize: 15),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            );
          }),
        ),
      ],
    );
  }
}

