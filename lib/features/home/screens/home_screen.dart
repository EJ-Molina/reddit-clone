import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/searchWidget.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';

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
          // Builder(
          //   builder: (context) {
          //     return IconButton(
          //       onPressed: () => showSearch(
          //         context: context,
          //         delegate: SearchCommunityDelegate(ref),
          //       ),
          //       icon: Icon(Icons.search),
          //     );
          //   }
          // ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchWidget()),
            ),
            icon: Icon(Icons.search),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => openEndDrawer(context),
                icon: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}
