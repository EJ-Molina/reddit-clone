import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 50,
            ),
            Text(
              'u/${user.name}',
              style: TextStyle(fontSize: 18, fontWeight: .w500),
            ),
            Gap(10),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My profile'),
              onTap: () => navigateToUserProfileScreen(context, user.uid),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Log Out'),
              onTap: () => logOut(ref),
            ),
            Gap(10),
            Switch.adaptive(
              value:
                  ref.watch(themeNotifierProvider).brightness ==
                  Brightness.dark,
              onChanged: (_) => toggleTheme(ref),
            ),
          ],
        ),
      ),
    );
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfileScreen(BuildContext context, String name) {
    Routemaster.of(context).push('/user-profile/$name');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }
}
