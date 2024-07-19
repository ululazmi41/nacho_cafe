import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nacho_cafe/core/local_repository.dart';
import 'package:nacho_cafe/domain/enum/menu_type_enum.dart';

class Menu {
  final String id;
  final String name;
  final int price;
  final String filename;
  const Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.filename,
  });
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

class MenuProvider extends ChangeNotifier {
  MenuState _state = MenuState.idle;
  get state => _state;

  SearchState _searchState = SearchState.idle;
  get searchState => _searchState;

  List<Menu> _searchMenus = [];
  get searchMenus => _searchMenus;

  List<Menu> _allMenus = [];
  List<Menu> _menus = [];
  List<Menu> get menus => _menus;

  late MenuType _selectedMenuType;
  MenuType get menuType => _selectedMenuType;

  LocalRepository localRepository;

  MenuProvider({
    required this.localRepository,
  }) {
    _selectedMenuType = MenuType.food;
    loadAllMenus();
    reloadMenuJson();
  }

  void loadAllMenus() async {
    _state = MenuState.idle;
    notifyListeners();

    _allMenus = await localRepository.getAllMenus();

    _state = MenuState.loaded;
    notifyListeners();
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

    late List<Menu> menus;
    if (_selectedMenuType == MenuType.food) {
      menus = await localRepository.getFoods();
    } else if (_selectedMenuType == MenuType.drink) {
      menus = await localRepository.getDrinks();
    } else {
      throw "Unhandled menu type: $_selectedMenuType";
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

  void search(String query) async {
    if (query == "") {
      _searchState = SearchState.idle;
      _searchMenus = await localRepository.getAllMenus();
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
