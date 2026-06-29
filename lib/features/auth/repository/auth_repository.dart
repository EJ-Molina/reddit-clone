import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required this._firestore,
    required this._auth,
    required this._googleSignIn,
  });

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {

      await _googleSignIn.initialize(
        serverClientId:
            '248755296662-ov8t3882jb8e6bal9p985sdugsnbf1dl.apps.googleusercontent.com',
      );

      // //Auth (sign in)
      final googleUser = await _googleSignIn.authenticate();

      // Authorization (for accessToken)
      var scopes = <String>['https://www.googleapis.com/auth/userinfo.email'];
      final googleAuth = await googleUser.authorizationClient
          .authorizationForScopes(scopes);

      String? accessToken = googleAuth?.accessToken;
      log("access: $accessToken");

      // if (accessToken == null) return;

      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
        accessToken: accessToken,
      );

      // credential
      var userCred = await _auth.signInWithCredential(credential);

      // // userModel
      late UserModel userModel;
      if (userCred.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCred.user!.displayName ?? 'No name',
          profilePic: userCred.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCred.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: <String>[],
        );

        // //fbase firestore
        await _users.doc(userCred.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCred.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseAuthException catch (ex) {
      //will go to catch
      return left(Failure(ex.toString()));
    } catch (e) {
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
  // Future<void> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   if (googleUser == null) return;

  //   final googleAuth = await googleUser.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   await _auth.signInWithCredential(credential);
  // }
}
