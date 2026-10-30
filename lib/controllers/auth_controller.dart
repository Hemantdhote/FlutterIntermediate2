import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_modal.dart';
import '../repositories/user_repository.dart';
import '../services/firebase_auth_service.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final UserRepository _userRepository = UserRepository();

  final isLoading = false.obs;

  User? get currentUser => _authService.currentUser;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final credential = await _authService.signUp(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Unable to create account.');
      }

      final trimmedName = name.trim();
      await user.updateDisplayName(trimmedName);

      final profile = UserModel(
        uid: user.uid,
        name: trimmedName,
        email: user.email ?? email.trim(),
        provider: 'email',
        createdAt: DateTime.now(),
      );

      await _userRepository.createProfile(profile);

      Get.snackbar(
        'Success',
        'Your account has been created.',
      );

      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Signup Failed',
        _authErrorMessage(e.code),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final credential = await _authService.login(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Unable to sign in.');
      }

      final profile = await _userRepository.getProfile(user.uid);

      if (profile == null) {
        final newProfile = UserModel(
          uid: user.uid,
          name: user.displayName ?? user.email?.split('@').first ?? 'User',
          email: user.email ?? email.trim(),
          provider: 'email',
          createdAt: DateTime.now(),
        );
        await _userRepository.createProfile(newProfile);
      }

      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        _authErrorMessage(e.code),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  String _authErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
