import 'package:get/get.dart';

import '../../views/splash/splash_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/my_blogs/my_blogs_screen.dart';
import '../../views/create_blog/create_blog_screen.dart';
import '../../views/blog_details/blog_details_screen.dart';
import 'app_routes.dart';

import '../../controllers/create_blog_controller.dart';
import '../../controllers/my_blogs_controller.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(
      name: AppRoutes.createBlog,
      page: () => const CreateBlogScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateBlogController>(() => CreateBlogController());
      }),
    ),
    GetPage(
      name: AppRoutes.myBlogs,
      page: () => const MyBlogsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MyBlogsController>(() => MyBlogsController());
      }),
    ),
    GetPage(
      name: AppRoutes.blogDetails,
      page: () => const BlogDetailsScreen(),
    ),
  ];
}
