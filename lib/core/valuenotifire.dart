import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> _favorites = {};

  Map<String, bool> get favorites => _favorites;

  FavoritesNotifier() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favoritesSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    _favorites = {for (var doc in favoritesSnapshot.docs) doc.id: true};
    notifyListeners();
  }

  Future<void> toggleFavorite(String doctorId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favoriteRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(doctorId);

    final favoriteSnapshot = await favoriteRef.get();

    if (favoriteSnapshot.exists) {
      await favoriteRef.delete();
      _favorites.remove(doctorId);
    } else {
      await favoriteRef.set({'doctorId': doctorId});
      _favorites[doctorId] = true;
    }

    notifyListeners();
  }

  bool isFavorite(String doctorId) {
    return _favorites[doctorId] ?? false;
  }
}
