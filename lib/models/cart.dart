import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSinlgeItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantily == 1) {
      _items.remove(productId);
    } else {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                productId: productId,
                name: existingItem.name,
                quantily: existingItem.quantily - 1,
                price: existingItem.price,
              ));
    }
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, CartItem) {
      total += (CartItem.price * CartItem.quantily);
    });
    return total;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void additem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) => CartItem(
          id: value.id,
          productId: value.productId,
          name: value.name,
          quantily: value.quantily + 1,
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantily: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }
}
