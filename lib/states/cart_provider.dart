import 'package:flutter/material.dart';
import 'package:nacho_cafe/core/local_repository.dart';
import 'package:nacho_cafe/states/menu_provider.dart';

class CartItem {
  final String id;
  int count;
  CartItem(this.id, this.count);
}

abstract class CartInterface {
  Future<Menu?> getCartItemDetail(String id);
  void addCartItem(String id, int count);
  void updateCartItemCount(String id, int count);
  void deleteCartItem(String id);
}

class CartProvider extends ChangeNotifier implements CartInterface {
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  LocalRepository localRepository;
  CartProvider({required this.localRepository});

  @override
  void addCartItem(String id, int count) {
    CartItem cartItem = CartItem(id, count);
    _cart.add(cartItem);
    notifyListeners();
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
  }

  @override
  void deleteCartItem(String id) {
    for (int i = 0; i < _cart.length; i++) {
      if (_cart[i].id == id) {
        _cart.removeAt(i);
      }
    }
  }
}
