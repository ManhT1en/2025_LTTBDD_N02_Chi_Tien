import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites => _favoriteIds;
  FavoriteProvider() {
    loadFavorites();
  }
  void toggleFavoriteStatus(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorites').doc(productId).set({
        'isFavorite': true,
      });
    } catch (e) {
      print('Đã có lỗi khi xóa món ăn yêu thích: $e');
    }
  }

  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorites').doc(productId).delete();
    } catch (e) {
      print('Đã có lỗi khi xóa món ăn yêu thích: $e');
    }
  }

  Future<void> loadFavorites() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userFavorites')
          .get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
      notifyListeners();
    } catch (e) {
      print('Đã có lỗi khi tải danh sách món ăn yêu thích: $e');
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of(context, listen: listen);
  }

  void toggleFavorite(DocumentSnapshot<Map<String, dynamic>> favoriteItem) {}
}
