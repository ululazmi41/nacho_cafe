import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;

enum FoodState {
  idle,
  loaded,
}

class Food {
  final String name;
  final int price;
  final String filename;
  const Food({required this.name, required this.price, required this.filename});
}

class FoodProvider extends ChangeNotifier {
  FoodState _state = FoodState.idle;
  get state => _state;

  List<Food> _foods = [];
  List<Food> get foods => _foods;

  FoodProvider() {
    dev.log('Initiating Food Provider');
    loadJson();
  }

  Future<void> loadJson() async {
    _state = FoodState.idle;

    String json = await rootBundle.loadString("assets/foods.json");
    List<dynamic> decoded = jsonDecode(json);

    for (var item in decoded) {
      if (item
          case {
            "name": String name,
            "price": int price,
            "filename": String filename,
          }) {
        Food food = Food(
          name: name,
          price: price,
          filename: filename,
        );
        foods.add(food);
      } else {
        throw "unhandled json: $item";
      }
    }

    _foods = foods;
    _state = FoodState.loaded;
    notifyListeners();
  }

  List<Food> getRandomFood(int total) {
    if (total == 0) {
      return [];
    }

    List<Food> picked = [];
    List<int> indexes = [];
    for (int i = 0; i < _foods.length; i++) {
      indexes.add(i);
    }
    for (int i = 0; i < total; i++) {
      int randomIndex = Random().nextInt(indexes.length);
      int index = indexes.removeAt(randomIndex);
      picked.add(_foods[index]);
    }
    return picked;
  }
}
