import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => openDrawer(context),
              icon: Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          IconButton(
            onPressed: () => openDrawer(context),
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}
