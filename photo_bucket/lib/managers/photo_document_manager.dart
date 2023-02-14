import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_bucket/models/photo.dart';

class PhotoDocumentManager {
  Photo? latestPhoto;
  final CollectionReference _ref;

  static final PhotoDocumentManager instance =
      PhotoDocumentManager._privateConstructor();

  PhotoDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kPhotoCollectionPath);

  StreamSubscription startListening(String documentId, Function observer) {
    return _ref
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      latestPhoto = Photo.from(docSnapshot);
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  void editPhoto({
    required String title,
    required String url,
  }) {
    if (latestPhoto == null) {
      return;
    }
    _ref.doc(latestPhoto!.documentId!).update({
      kPhoto_title: title,
      kPhoto_url: url,
      kPhoto_lastTouched: Timestamp.now(),
    }).catchError((error) => print("Failed to edit the photo: $error"));
  }

  Future<void> delete() {
    return _ref.doc(latestPhoto?.documentId!).delete();
  }
}
