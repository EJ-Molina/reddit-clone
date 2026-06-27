import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_screen.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref
          .watch(getUserCommunityByNameProvider(name))
          .when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(community.banner, fit: .cover),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: .all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: .topLeft,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: TextStyle(fontWeight: .bold, fontSize: 19),
                            ),
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () =>
                                        navigateToModTools(context),
                                    style: OutlinedButton.styleFrom(
                                      padding: .symmetric(horizontal: 25),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .circular(20),
                                      ),
                                      foregroundColor: Colors.blue,
                                    ),
                                    child: Text('Mod Tools'),
                                  )
                                : OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      padding: .symmetric(horizontal: 25),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .circular(20),
                                      ),
                                      foregroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      community.members.contains(user.uid)
                                          ? 'Joined'
                                          : 'Join',
                                    ),
                                  ),
                          ],
                        ),
                        Padding(
                          padding: .only(top: 10),
                          child: Text('${community.members.length} members'),
                        ),
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

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }
}
