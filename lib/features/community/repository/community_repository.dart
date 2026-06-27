import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/community.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required this._firestore});

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (ex) {
      return left(Failure(ex.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((e) {
          List<Community> communities = [];
          debugPrint(e.size.toString());
          for (var doc in e.docs) {
            communities.add(
              Community.fromMap(doc.data() as Map<String, dynamic>),
            );
          }
          return communities;
        });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities
        .doc(name)
        .snapshots()
        .map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (ex) {
      throw ex.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return _communities.where('name', isEqualTo: '').snapshots().map((event) {
        final communities = <Community>[];
        for (final doc in event.docs) {
          communities.add(
            Community.fromMap(doc.data() as Map<String, dynamic>),
          );
        }
        return communities;
      });
    }

    return _communities
        .orderBy('name')
        .startAt([trimmedQuery])
        .endAt(['$trimmedQuery\uf8ff'])
        .snapshots()
        .map((event) {
          final communities = <Community>[];
          for (final doc in event.docs) {
            communities.add(
              Community.fromMap(doc.data() as Map<String, dynamic>),
            );
          }
          return communities;
        });
  }

  FutureVoid joinCommunity(String communityName, String uid) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'members': FieldValue.arrayUnion([uid]),
        }),
      );
    } on FirebaseException catch (ex) {
      throw ex.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

   FutureVoid leaveCommunity(String communityName, String uid) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'members': FieldValue.arrayRemove([uid]),
        }),
      );
    } on FirebaseException catch (ex) {
      throw ex.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  //experiment
  Stream<List<Community>> searchEj(String query) {
    return _communities
        .where('name', isEqualTo: query.trim().toLowerCase())
        .snapshots()
        .map((data) {
          List<Community> communities = [];
          for (var community in data.docs) {
            debugPrint(community['name']);
            communities.add(
              Community.fromMap(community.data() as Map<String, dynamic>),
            );
          }
          return communities;
        });
  }
}
