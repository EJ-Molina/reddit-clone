import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(getUserCommunityByNameProvider(name))
          .when(
            data: (data) => Column(),
            error: (error, stackTracing) =>
                ErrorScreen(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
