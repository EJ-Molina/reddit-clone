import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Create Community'), centerTitle: true),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  Align(
                    alignment: .topLeft,
                    child: Text(
                      'Community name',
                      style: TextStyle(color: Colors.white, fontWeight: .bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: communityCtr,
                    decoration: InputDecoration(
                      hintText: 'r/Community_name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0, style: .none),
                      ),
                      fillColor: const Color.fromARGB(122, 48, 48, 48),
                      filled: true,
                      contentPadding: .all(18),
                    ),
                    maxLength: 21,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: createCommunity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(20),
                      ),
                    ),
                    child: Text('Create Community '),
                  ),
                ],
              ),
            ),
    );
  }


  void createCommunity() async {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityCtr.text, context);
  }
}
