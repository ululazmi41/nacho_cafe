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

enum SearchState {
  idle,
  hasItem,
  noItem,
}

enum MenuType {
  food,
  drink,
}

class MenuProvider extends ChangeNotifier {
  MenuState _state = MenuState.idle;
  get state => _state;

  SearchState _searchState = SearchState.idle;
  get searchState => _searchState;

  List<Menu> _searchMenus = [];
  get searchMenus => _searchMenus;

  List<Menu> _menus = [];
  List<Menu> get menus => _menus;

  List<Menu> _allMenus = [];

  late MenuType _selectedMenuType;
  MenuType get menuType => _selectedMenuType;

  MenuProvider() {
    _selectedMenuType = MenuType.food;
    initAllMenus();
    reloadMenuJson();
  }

  void initAllMenus() async {
    const String foodUrl = "assets/foods.json";
    const String drinkUrl = "assets/drinks.json";

    String foodJson = await rootBundle.loadString(foodUrl);
    String drinkJson = await rootBundle.loadString(drinkUrl);

    List<dynamic> decodedFood = jsonDecode(foodJson);
    List<dynamic> decodedDrink = jsonDecode(drinkJson);

    List<Menu> result = [];
    void load(List<dynamic> decoded) {
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
          result.add(menu);
        } else {
          throw "unhandled json: $item";
        }
      }
    }

    load(decodedFood);
    load(decodedDrink);

    result.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    _allMenus = result;
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

  void search(String query) {
    if (query == "") {
      _searchState = SearchState.idle;
      _searchMenus = _allMenus;
      notifyListeners();
      return;
    }

    List<Menu> result = [];
    for (Menu menu in _allMenus) {
      final bool isIncludeName = menu.name.toLowerCase().contains(query);
      final bool isIncludePrice = menu.price.toString().contains(query);
      if (isIncludeName || isIncludePrice) {
        result.add(menu);
      }
    }

    if (result.isNotEmpty) {
      _searchState = SearchState.hasItem;
    } else {
      _searchState = SearchState.noItem;
    }
    _searchMenus = result;
    notifyListeners();
  }
}
