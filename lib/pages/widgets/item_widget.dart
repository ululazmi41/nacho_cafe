import 'package:flutter/material.dart';
import 'package:nacho_cafe/pages/widgets/item_dialog.dart';
import 'package:nacho_cafe/states/cart_provider.dart';
import 'package:nacho_cafe/states/menu_provider.dart';
import 'package:nacho_cafe/utils/helper.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    super.key,
    required this.width,
    required this.height,
    required this.menu,
    required this.nameFontSize,
    required this.priceFontSize,
  });

  final double width;
  final double height;
  final Menu menu;
  final double nameFontSize;
  final double priceFontSize;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
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
        CartItem? cartItem = Provider.of<CartProvider>(context, listen: false)
            .getCartItem(widget.menu.id);

        if (cartItem != null) {
          _itemCount = cartItem.count;
        }

        showItemDialog(
          context,
          isNotAdded: cartItem == null,
          menu: widget.menu,
          count: cartItem?.count ?? 1,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/${widget.menu.filename}"),
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
                      widget.menu.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: widget.nameFontSize,
                      ),
                    ),
                    Text(
                      formatToRupiah(widget.menu.price),
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
    required Menu menu,
    required bool isNotAdded,
    String? id,
    int? count,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: SizedBox(
            width: 200.0,
            height: 200.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset("images/${widget.menu.filename}"),
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
                      widget.menu.name,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      formatToRupiah(widget.menu.price),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                ItemDialog(
                  price: widget.menu.price,
                  id: id,
                  count: count,
                  parentIncrease: increaseItemCount,
                  parentDecrease: decreaseItemCount,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
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
                if (isNotAdded) {
                  Provider.of<CartProvider>(context, listen: false)
                      .addCartItem(menu, menu.id, _itemCount);
                } else {
                  Provider.of<CartProvider>(context, listen: false)
                      .updateCartItemCount(menu.id, _itemCount);
                }
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                isNotAdded ? "Tambah" : "Ubah",
                style: const TextStyle(
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

class ItemPlaceholder extends StatefulWidget {
  const ItemPlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<ItemPlaceholder> createState() => _ItemPlaceholderState();
}

class _ItemPlaceholderState extends State<ItemPlaceholder>
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
