import 'package:flutter/material.dart';
import 'package:nacho_cafe/pages/widgets/item_dialog.dart';
import 'package:nacho_cafe/utils/helper.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({
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
                ItemDialog(
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
