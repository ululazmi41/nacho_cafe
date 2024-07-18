import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/pages/widgets/item_widget.dart';
import 'package:nacho_cafe/states/cart_provider.dart';
import 'package:nacho_cafe/states/menu_provider.dart';
import 'package:nacho_cafe/utils/routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(
            left: 12.0,
          ),
          child: SvgPicture.asset(
            'images/ic_brand.svg',
            width: 24.0,
            height: 24.0,
            semanticsLabel: 'brand logo',
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
        ),
        title: const Opacity(
          opacity: 0.7,
          child: Text(
            "Nacho Cafe",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, searchPageRoute);
            },
            child: SvgPicture.asset(
              "images/ic_search.svg",
              width: 28.0,
              height: 28.0,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 28.0,
            height: 28.0,
            child: Stack(
              children: [
                SvgPicture.asset(
                  "images/ic_cart.svg",
                  width: 28.0,
                  height: 28.0,
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                Consumer<CartProvider>(
                  builder: (context, value, child) {
                    if (value.cart.isNotEmpty) {
                      return Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 18.0),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _TypeButtonsWidget(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              _RecommendationWidget(),
              SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _ItemsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeButtonsWidget extends StatefulWidget {
  const _TypeButtonsWidget();

  @override
  State<_TypeButtonsWidget> createState() => _TypeButtonsWidgetState();
}

class _TypeButtonsWidgetState extends State<_TypeButtonsWidget> {
  MenuType menuType = MenuType.food;

  final ColorFilter _elevatedColorFilter = const ColorFilter.mode(
    Colors.white,
    BlendMode.srcIn,
  );

  final ColorFilter _outlinedColorFilter = const ColorFilter.mode(
    Colors.grey,
    BlendMode.srcIn,
  );

  final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    backgroundColor: Colors.red,
  );

  final ButtonStyle _outlinedButtonStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  );

  final TextStyle _elevatedTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  final TextStyle _outlinedTextStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            value.menuType == MenuType.food
                ? ElevatedButton(
                    onPressed: () {
                      changeMenuType(context, MenuType.food);
                    },
                    style: _elevatedButtonStyle,
                    child: _foodButtonBody(
                      colorFilter: _elevatedColorFilter,
                      textStyle: _elevatedTextStyle,
                    ),
                  )
                : OutlinedButton(
                    onPressed: () {
                      changeMenuType(context, MenuType.food);
                    },
                    style: _outlinedButtonStyle,
                    child: _foodButtonBody(
                      colorFilter: _outlinedColorFilter,
                      textStyle: _outlinedTextStyle,
                    ),
                  ),
            const SizedBox(width: 12.0),
            value.menuType == MenuType.drink
                ? ElevatedButton(
                    onPressed: () {
                      changeMenuType(context, MenuType.drink);
                    },
                    style: _elevatedButtonStyle,
                    child: _drinkButtonBody(
                      colorFilter: _elevatedColorFilter,
                      textStyle: _elevatedTextStyle,
                    ),
                  )
                : OutlinedButton(
                    onPressed: () {
                      changeMenuType(context, MenuType.drink);
                    },
                    style: _outlinedButtonStyle,
                    child: _drinkButtonBody(
                      colorFilter: _outlinedColorFilter,
                      textStyle: _outlinedTextStyle,
                    ),
                  ),
          ],
        );
      },
    );
  }

  Row _foodButtonBody({
    required ColorFilter colorFilter,
    required TextStyle textStyle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          "images/ic_food.svg",
          width: 24.0,
          height: 24.0,
          colorFilter: colorFilter,
        ),
        const SizedBox(width: 12.0),
        Text(
          "Makanan",
          style: textStyle,
        ),
      ],
    );
  }

  Row _drinkButtonBody({
    required ColorFilter colorFilter,
    required TextStyle textStyle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          "images/ic_drink.svg",
          width: 24.0,
          height: 24.0,
          colorFilter: colorFilter,
        ),
        const SizedBox(width: 12.0),
        Text(
          "Minuman",
          style: textStyle,
        ),
      ],
    );
  }

  void changeMenuType(BuildContext context, MenuType menuType) {
    Provider.of<MenuProvider>(context, listen: false).changeMenuType(menuType);
  }
}

class _RecommendationWidget extends StatefulWidget {
  const _RecommendationWidget();

  @override
  State<_RecommendationWidget> createState() => _RecommendationWidgetState();
}

class _ItemsWidget extends StatefulWidget {
  const _ItemsWidget();

  @override
  State<_ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<_ItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, value, child) {
        if (value.state == MenuState.idle) {
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              12,
              (int index) {
                return const ItemPlaceholder(
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          );
        } else if (value.state == MenuState.loaded) {
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              value.menus.length,
              (int index) {
                return ItemWidget(
                  width: double.infinity,
                  height: double.infinity,
                  name: value.menus[index].name,
                  nameFontSize: 16.0,
                  price: value.menus[index].price,
                  priceFontSize: 14.0,
                  imageUrl: "images/${value.menus[index].filename}",
                );
              },
            ),
          );
        } else {
          return const Text("Unreachable code");
        }
      },
    );
  }
}

class _RecommendationWidgetState extends State<_RecommendationWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, value, child) {
        if (value.state == MenuState.idle) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).width / 3,
            child: Expanded(
              child: ListView.separated(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 12.0);
                },
                itemBuilder: (context, index) {
                  return ItemPlaceholder(
                    width: MediaQuery.sizeOf(context).width / 3,
                    height: MediaQuery.sizeOf(context).width / 3,
                  );
                },
              ),
            ),
          );
        } else if (value.state == MenuState.loaded) {
          List<Menu> foods = value.getRandomMenu(5);
          return SizedBox(
            height: MediaQuery.sizeOf(context).width / 3,
            child: Expanded(
              child: ListView.separated(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 12.0);
                },
                itemBuilder: (context, index) {
                  return ItemWidget(
                    width: MediaQuery.sizeOf(context).width / 3,
                    height: MediaQuery.sizeOf(context).width / 3,
                    name: foods[index].name,
                    nameFontSize: 12.0,
                    price: foods[index].price,
                    priceFontSize: 10.0,
                    imageUrl: "images/${foods[index].filename}",
                  );
                },
              ),
            ),
          );
        } else {
          return const Text("Unreachable code");
        }
      },
    );
  }
}
