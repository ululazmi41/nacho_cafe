import 'package:flutter/material.dart';
import 'package:nacho_cafe/core/local_repository.dart';
import 'package:nacho_cafe/states/menu_provider.dart';

class CartItem {
  final String id;
  final Menu menu;
  int count;
  CartItem(this.id, this.menu, this.count);
}

abstract class CartInterface {
  CartItem? getCartItem(String id);
  Future<Menu?> getCartItemDetail(String id);
  void addCartItem(Menu menu, String id, int count);
  void updateCartItemCount(String id, int count);
  void deleteCartItem(String id);
  void reset();
}

class CartProvider extends ChangeNotifier implements CartInterface {
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  LocalRepository localRepository;
  CartProvider({required this.localRepository});

  @override
  void addCartItem(Menu menu, String id, int count) {
    CartItem cartItem = CartItem(id, menu, count);
    _cart.add(cartItem);
    notifyListeners();
  }

  @override
  CartItem? getCartItem(String id) {
    for (CartItem cartItem in _cart) {
      if (cartItem.id == id) {
        return cartItem;
      }
    }
    return null;
  }

  @override
  Future<Menu?> getCartItemDetail(String id) async {
    return await localRepository.get(id);
  }

  @override
  void updateCartItemCount(String id, int count) {
    for (CartItem cartItem in _cart) {
      if (cartItem.id == id) {
        cartItem.count = count;
      }
    }
    notifyListeners();
  }

  @override
  void deleteCartItem(String id) {
    for (int i = 0; i < _cart.length; i++) {
      if (_cart[i].id == id) {
        _cart.removeAt(i);
      }
    }
    notifyListeners();
  }

  @override
  void reset() {
    while (_cart.isNotEmpty) {
      _cart.removeLast();
    }
    notifyListeners();
  }
}
