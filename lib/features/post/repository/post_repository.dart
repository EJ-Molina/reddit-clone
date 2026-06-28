import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/post.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firebaseFirestore: ref.watch(firestoreProvider));
});

class PostRepository {
  PostRepository({required this._firebaseFirestore});
  final FirebaseFirestore _firebaseFirestore;

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (ex) {
      throw ex.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
