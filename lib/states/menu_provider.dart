import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Menu {
  final String name;
  final int price;
  final String filename;
  const Menu({required this.name, required this.price, required this.filename});
}

enum MenuState {
  idle,
  loaded,
}

enum MenuType {
  food,
  drink,
}

class MenuProvider extends ChangeNotifier {
  late MenuState _state;
  get state => _state;

  late List<Menu> _menus;
  List<Menu> get menus => _menus;

  late MenuType _selectedMenuType;
  MenuType get menuType => _selectedMenuType;

  MenuProvider() {
    _state = MenuState.idle;
    _menus = [];

    _selectedMenuType = MenuType.food;
    reloadMenuJson();
  }

  void changeMenuType(MenuType menuType) {
    if (menuType != _selectedMenuType) {
      _selectedMenuType = menuType;
      _state = MenuState.idle;
      _menus = [];
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 600), () {
        reloadMenuJson();
      });
    }
  }

  Future<void> reloadMenuJson() async {
    _state = MenuState.idle;
    _menus = [];
    notifyListeners();

    late String menuUrl;
    if (menuType == MenuType.food) {
      menuUrl = "assets/foods.json";
    } else if (menuType == MenuType.drink) {
      menuUrl = "assets/drinks.json";
    } else {
      throw "Unhandled Menu Type: $menuType";
    }

    String json = await rootBundle.loadString(menuUrl);
    List<dynamic> decoded = jsonDecode(json);

    for (var item in decoded) {
      if (item
          case {
            "name": String name,
            "price": int price,
            "filename": String filename,
          }) {
        Menu menu = Menu(
          name: name,
          price: price,
          filename: filename,
        );
        menus.add(menu);
      } else {
        throw "unhandled json: $item";
      }
    }

    _menus = menus;
    _state = MenuState.loaded;
    notifyListeners();
  }

  List<Menu> getRandomMenu(int total) {
    if (total == 0) {
      return [];
    }

    List<Menu> picked = [];
    List<int> indexes = [];
    for (int i = 0; i < _menus.length; i++) {
      indexes.add(i);
    }
    for (int i = 0; i < total; i++) {
      int randomIndex = Random().nextInt(indexes.length);
      int index = indexes.removeAt(randomIndex);
      picked.add(_menus[index]);
    }
    return picked;
  }
}
