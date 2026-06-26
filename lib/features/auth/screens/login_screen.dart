import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath, height: 40),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Skip', style: TextStyle(fontWeight: .bold)),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Dive into anything',
                  style: TextStyle(
                    fontWeight: .bold,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(Constants.loginEmote, height: 400),
                ),
                SizedBox(height: 20),
                const SignInButton(),
              ],
            ),
    );
  }
}
