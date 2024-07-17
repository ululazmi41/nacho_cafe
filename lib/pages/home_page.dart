import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/states/menu_provider.dart';
import 'package:provider/provider.dart';

String formatToRupiah(int price) {
  String reversedPrice = price.toString().split('').reversed.join();
  List<String> chunks = [];
  for (int i = 0; i < reversedPrice.length; i += 3) {
    late String chunk;
    if (i < reversedPrice.length - 3) {
      chunk = reversedPrice.substring(i, i + 3);
    } else {
      chunk = reversedPrice.substring(i);
    }
    chunks.add(chunk);
  }
  String formattedPrice = chunks.join('.').split('').reversed.join();
  return 'Rp $formattedPrice';
}

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
          SvgPicture.asset(
            "images/ic_search.svg",
            width: 28.0,
            height: 28.0,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(width: 12.0),
          SvgPicture.asset(
            "images/ic_cart.svg",
            width: 28.0,
            height: 28.0,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(width: 18.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<MenuProvider>(context, listen: false)
                          .changeMenuType(MenuType.food);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "images/ic_food.svg",
                          width: 24.0,
                          height: 24.0,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        const Text(
                          "Makanan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  OutlinedButton(
                    onPressed: () {
                      Provider.of<MenuProvider>(context, listen: false)
                          .changeMenuType(MenuType.drink);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "images/ic_drink.svg",
                          width: 24.0,
                          height: 24.0,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        const Text(
                          "Makanan",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Align(
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
                  const SizedBox(height: 8.0),
                  Consumer<MenuProvider>(
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
                                return _ItemPlaceholder(
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
                                return Item(
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
                  ),
                  const SizedBox(height: 8.0),
                  const Align(
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
                  Consumer<MenuProvider>(
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
                              return const _ItemPlaceholder(
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
                              return Item(
                                width: double.infinity,
                                height: double.infinity,
                                name: value.menus[index].name,
                                nameFontSize: 16.0,
                                price: value.menus[index].price,
                                priceFontSize: 14.0,
                                imageUrl:
                                    "images/${value.menus[index].filename}",
                              );
                            },
                          ),
                        );
                      } else {
                        return const Text("Unreachable code");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  const Item({
    super.key,
    required this.width,
    required this.height,
    required this.name,
    required this.nameFontSize,
    required this.price,
    required this.priceFontSize,
    required this.imageUrl,
  });

  final double width;
  final double height;
  final String name;
  final double nameFontSize;
  final int price;
  final double priceFontSize;
  final String imageUrl;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  // this widget's _itemCount should always reflect ItemCount's _itemCount
  int _itemCount = 1;

  void increaseItemCount() {
    setState(() {
      _itemCount += 1;
    });
  }

  void decreaseItemCount() {
    setState(() {
      if (_itemCount > 1) {
        _itemCount -= 1;
      }
    });
  }

  void resetItemCount() {
    setState(() {
      _itemCount = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showItemDialog(
          context,
          name: widget.name,
          price: widget.price,
          imageUrl: widget.imageUrl,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: widget.width,
                  height: (widget.height / 2) + (widget.height / 4),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.red, Colors.transparent],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: widget.nameFontSize,
                      ),
                    ),
                    Text(
                      formatToRupiah(widget.price),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: widget.priceFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showItemDialog(
    BuildContext context, {
    required String name,
    required int price,
    required String imageUrl,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
            width: 200.0,
            height: 200.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(imageUrl),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      formatToRupiah(price),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                DialogContent(
                  price: price,
                  parentIncrease: increaseItemCount,
                  parentDecrease: decreaseItemCount,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Kembali',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Tambah',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      resetItemCount();
    });
  }
}

class _ItemPlaceholder extends StatefulWidget {
  const _ItemPlaceholder({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<_ItemPlaceholder> createState() => _ItemPlaceholderState();
}

class _ItemPlaceholderState extends State<_ItemPlaceholder>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _controller.repeat(reverse: true);
    _colorTween =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: _colorTween.value,
            borderRadius: BorderRadius.circular(12.0),
          ),
        );
      },
    );
  }
}

class DialogContent extends StatefulWidget {
  const DialogContent({
    super.key,
    required this.price,
    required this.parentDecrease,
    required this.parentIncrease,
  });

  final int price;
  final Function parentIncrease;
  final Function parentDecrease;

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  int _itemCount = 1;

  void increaseItemCount() {
    setState(() {
      _itemCount += 1;
    });
  }

  void decreaseItemCount() {
    setState(() {
      if (_itemCount > 1) {
        _itemCount -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatToRupiah(widget.price * _itemCount),
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                decreaseItemCount();
                widget.parentDecrease();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SvgPicture.asset(
                      "images/ic_left.svg",
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              "$_itemCount",
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(width: 12.0),
            InkWell(
              onTap: () {
                increaseItemCount();
                widget.parentIncrease();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SvgPicture.asset(
                      "images/ic_right.svg",
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
