import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_bucket/managers/auth_manager.dart';
import 'package:photo_bucket/models/photo.dart';

class PhotoCollectionManager {
  List<Photo> latestPhotos = [];
  final CollectionReference _ref;

  static final PhotoCollectionManager instance =
      PhotoCollectionManager._privateConstructor();

  PhotoCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kPhotoCollectionPath);

  StreamSubscription startListening(Function() observer,
      {bool isFilteredForMine = false}) {
    Query query = _ref.orderBy(kPhoto_lastTouched, descending: true);
    if (isFilteredForMine) {
      query =
          query.where(kPhoto_authorUID, isEqualTo: AuthManager.instance.uid);
    }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      latestPhotos = querySnapshot.docs.map((doc) => Photo.from(doc)).toList();
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> addPhoto({
    required String title,
    required String url,
  }) {
    return _ref
        .add({
          kPhoto_authorUID: AuthManager.instance.uid,
          kPhoto_title: title,
          kPhoto_url: url,
          kPhoto_lastTouched: Timestamp.now(),
        })
        .then((DocumentReference docRef) =>
            print("Photo added with id ${docRef.id}"))
        .catchError((error) => print("Failed to add Photo: $error"));
  }

  Query<Photo> get allPhotosQuery =>
      _ref.orderBy(kPhoto_lastTouched, descending: true).withConverter<Photo>(
            fromFirestore: (snapshot, _) => Photo.from(snapshot),
            toFirestore: (p, _) => p.toMap(),
          );

  Query<Photo> get mineOnlyPhotosQuery => allPhotosQuery.where(kPhoto_authorUID,
      isEqualTo: AuthManager.instance.uid);
}
