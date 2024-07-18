import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nacho_cafe/states/menu_provider.dart';

abstract class LocalInterface {
  Future<List<Menu>> getAllMenus();
  Future<List<Menu>> getFoods();
  Future<List<Menu>> getDrinks();
}

class LocalRepository implements LocalInterface {
  const LocalRepository();

  @override
  Future<List<Menu>> getAllMenus() async {
    const String foodUrl = "assets/foods.json";
    const String drinkUrl = "assets/drinks.json";

    String foodJson = await rootBundle.loadString(foodUrl);
    String drinkJson = await rootBundle.loadString(drinkUrl);

    List<dynamic> decodedFood = jsonDecode(foodJson);
    List<dynamic> decodedDrink = jsonDecode(drinkJson);

    List<Menu> load(List<dynamic> decoded) {
      List<Menu> result = [];
      for (var item in decoded) {
        if (item
            case {
              "id": String id,
              "name": String name,
              "price": int price,
              "filename": String filename,
            }) {
          Menu menu = Menu(
            id: id,
            name: name,
            price: price,
            filename: filename,
          );
          result.add(menu);
        } else {
          throw "unhandled json: $item";
        }
      }
      return result;
    }

    List<Menu> foods = load(decodedFood);
    List<Menu> drinks = load(decodedDrink);

    List<Menu> combined = [];
    for (Menu menu in foods) {
      combined.add(menu);
    }
    for (Menu menu in drinks) {
      combined.add(menu);
    }

    combined.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    return combined;
  }

  @override
  Future<List<Menu>> getFoods() async {
    const String path = "assets/foods.json";
    String json = await rootBundle.loadString(path);
    List<dynamic> decoded = jsonDecode(json);
    List<Menu> foods = [];
    for (var item in decoded) {
      if (item
          case {
            "id": String id,
            "name": String name,
            "price": int price,
            "filename": String filename,
          }) {
        Menu menu = Menu(
          id: id,
          name: name,
          price: price,
          filename: filename,
        );
        foods.add(menu);
      } else {
        throw "unhandled json: $item";
      }
    }
    return foods;
  }

  @override
  Future<List<Menu>> getDrinks() async {
    const String path = "assets/drinks.json";
    String json = await rootBundle.loadString(path);
    List<dynamic> decoded = jsonDecode(json);
    List<Menu> drinks = [];
    for (var item in decoded) {
      if (item
          case {
            "id": String id,
            "name": String name,
            "price": int price,
            "filename": String filename,
          }) {
        Menu menu = Menu(
          id: id,
          name: name,
          price: price,
          filename: filename,
        );
        drinks.add(menu);
      } else {
        throw "unhandled json: $item";
      }
    }
    return drinks;
  }

  Future<Menu?> get(String id) async {
    List<Menu> menus = await getAllMenus();

    for (Menu menu in menus) {
      if (menu.id == id) {
        return menu;
      }
    }
    return null;
  }
}
