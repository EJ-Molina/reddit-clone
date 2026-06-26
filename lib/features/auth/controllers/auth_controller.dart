import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChange;
});


final getUserDataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required this._authRepository, required this._ref})
    : super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackbar(context, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
