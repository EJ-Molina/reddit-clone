import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepositoryProvider(firebaseStorage: ref.watch(firebaseStorageProvider));
});

class StorageRepositoryProvider {
  final FirebaseStorage _firebaseStorage;

  StorageRepositoryProvider({required this._firebaseStorage});

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      //stores image in fbase
      var uploadTask = await ref.putFile(file!);

      return right(await uploadTask.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
