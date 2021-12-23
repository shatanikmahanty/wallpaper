import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/configs/configs.dart';

class LikedImagesBloc extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List _likedImages = [];

  List get likedImages => _likedImages;

  Future getLikedImages(String uid) async {
    _isLoading = true;
    notifyListeners();
    DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore
        .instance
        .collection(Configs.users)
        .doc(uid)
        .get();

    if (docRef.data() == null) {
      _isLoading = false;
      notifyListeners();
      return;
    } else {
      _likedImages = (docRef.data() ?? {}).containsKey('liked')
          ? docRef.data()!['liked']
          : [];
      _isLoading = false;
      notifyListeners();
    }
  }

  Future addNewLike(String uid, String url) async {
    DocumentSnapshot<Map<String, dynamic>>? docRef = await FirebaseFirestore
        .instance
        .collection(Configs.users)
        .doc(uid)
        .get();

    if (docRef.data() != null) {
      _likedImages = (docRef.data() ?? {}).containsKey('liked')
          ? docRef.data()!['liked']
          : [];
      _likedImages.add(url);
    } else {
      _likedImages = [];
    }

    await FirebaseFirestore.instance.collection(Configs.users).doc(uid).update({
      'liked': likedImages,
    });

    notifyListeners();
  }

  Future removeLike(String uid, String url) async {
    DocumentSnapshot<Map<String, dynamic>>? docRef = await FirebaseFirestore
        .instance
        .collection(Configs.users)
        .doc(uid)
        .get();

    _likedImages = (docRef.data() ?? {}).containsKey('liked')
        ? docRef.data()!['liked']
        : [];
    _likedImages.remove(url);

    await FirebaseFirestore.instance.collection(Configs.users).doc(uid).update({
      'liked': likedImages,
    });

    notifyListeners();
  }
}
