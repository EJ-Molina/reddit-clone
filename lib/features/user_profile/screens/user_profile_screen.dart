import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(getUserDataProvider(uid))
          .when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(user.banner, fit: .cover),
                        ),
                        Container(
                          alignment: .bottomLeft,
                          padding: EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(user.profilePic),
                          ),
                        ),
                        Container(
                          alignment: .bottomLeft,
                          padding: .all(20),
                          child: OutlinedButton(
                            onPressed: () =>
                                navigateToEditProfileScreen(context),
                            style: OutlinedButton.styleFrom(
                              padding: .symmetric(horizontal: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(20),
                              ),
                              foregroundColor: Colors.blue,
                            ),
                            child: Text('Edit Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: .all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              'r/${user.name}',
                              style: TextStyle(fontWeight: .bold, fontSize: 19),
                            ),
                          ],
                        ),
                        Padding(
                          padding: .only(top: 10),
                          child: Text('${user.karma} karma'),
                        ),
                        Gap(10),
                        Divider(thickness: 2),
                      ]),
                    ),
                  ),
                ];
              },
              body: Container(),
            ),
            error: (error, stackTracing) =>
                ErrorScreen(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  void navigateToEditProfileScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }
}
