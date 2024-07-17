
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/utils/helper.dart';

class ItemDialog extends StatefulWidget {
  const ItemDialog({
    super.key,
    required this.price,
    required this.parentDecrease,
    required this.parentIncrease,
  });

  final int price;
  final Function parentIncrease;
  final Function parentDecrease;

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
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
