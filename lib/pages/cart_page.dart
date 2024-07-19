import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/pages/widgets/cart_dialog_state.dart';
import 'package:nacho_cafe/states/cart_provider.dart';
import 'package:nacho_cafe/utils/helper.dart';
import 'package:nacho_cafe/utils/routes.dart';
import 'package:provider/provider.dart';

enum PaymentType {
  cash,
  bri,
  dana,
}

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late int total;
  late int subTotal;
  late bool isNotEmpty;
  PaymentType currentSelection = PaymentType.cash;

  @override
  void initState() {
    super.initState();
    recountTotal();
  }

  void recountTotal() {
    total = 0;
    int recountSubTotal = 0;
    List<CartItem> items =
        Provider.of<CartProvider>(context, listen: false).cart;
    for (CartItem item in items) {
      recountSubTotal += item.menu.price * item.count;
    }
    setState(() {
      isNotEmpty = items.isNotEmpty;
      subTotal = recountSubTotal;
      total = (recountSubTotal * 0.9).floor();
    });
  }

  void selecting(PaymentType paymentType) {
    setState(() {
      currentSelection = paymentType;
    });
  }

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pesanan",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),
              Consumer<CartProvider>(builder: (context, value, child) {
                if (value.cart.isNotEmpty) {
                  if (value.cart.length < 2) {
                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12.0);
                          },
                          itemCount: value.cart.length,
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              cartItem: value.cart[index],
                              recountTotal: recountTotal,
                            );
                          },
                        ),
                        const SizedBox(height: 12.0),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12.0);
                          },
                          itemCount: 2 - value.cart.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: MediaQuery.of(context).size.width * 0.2,
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12.0);
                    },
                    itemCount: value.cart.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        cartItem: value.cart[index],
                        recountTotal: recountTotal,
                      );
                    },
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.width * 0.2,
                    child: const Center(
                      child: Text(
                        "Belum Memesan",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 24.0),
              const Text(
                "Metode Pembayaran",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              PaymentTypeWidget(
                paymentType: PaymentType.cash,
                currentSelection: currentSelection,
                imageUrl: "images/ic_cash.png",
                name: "Bayar di Kasir",
                onTap: () {
                  selecting(PaymentType.cash);
                },
              ),
              const SizedBox(height: 8.0),
              PaymentTypeWidget(
                paymentType: PaymentType.bri,
                currentSelection: currentSelection,
                imageUrl: "images/ic_bri.png",
                name: "BRI",
                onTap: () {
                  selecting(PaymentType.bri);
                },
              ),
              const SizedBox(height: 8.0),
              PaymentTypeWidget(
                paymentType: PaymentType.dana,
                currentSelection: currentSelection,
                imageUrl: "images/ic_dana.png",
                name: "Dana",
                onTap: () {
                  selecting(PaymentType.dana);
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal"),
                  Text(formatToRupiah(subTotal)),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Promo"),
                  Text("10%"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatToRupiah(total),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (isNotEmpty) {
                      showConfirmationDialog(context);
                    } else {
                      //
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isNotEmpty ? Colors.red : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Konfirmasi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SvgPicture.asset(
              "images/ic_food.svg",
              width: 80.0,
              height: 80.0,
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    "Konfirmasi",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Anda yakin ingin memesan?",
                    style: TextStyle(fontSize: 16.0),
                  ),
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
                'Batalkan',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushReplacementNamed(statusPageRoute);
                Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).reset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Yakin",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PaymentTypeWidget extends StatelessWidget {
  const PaymentTypeWidget({
    super.key,
    required this.paymentType,
    required this.currentSelection,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  final PaymentType paymentType;
  final PaymentType currentSelection;
  final String name;
  final String imageUrl;
  final Function onTap;

  final _colorSelected = Colors.black;
  final _colorDisabled = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: currentSelection == paymentType
                ? _colorSelected
                : _colorDisabled,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(
                imageUrl,
                width: 32.0,
                height: 32.0,
              ),
              const SizedBox(width: 24.0),
              Text(
                name,
                style: TextStyle(
                  color: currentSelection == paymentType
                      ? _colorSelected
                      : _colorDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.recountTotal,
  });

  final CartItem cartItem;
  final Function recountTotal;

  @override
  State<CartItemWidget> createState() => _StateCartItemWidget();
}

class _StateCartItemWidget extends State<CartItemWidget> {
  // this widget's _itemCount should always reflect ItemCount's _itemCount
  late int _itemCount;

  @override
  void initState() {
    super.initState();
    final CartItem? cartItem = Provider.of<CartProvider>(context, listen: false)
        .getCartItem(widget.cartItem.id);
    _itemCount = cartItem!.count;
  }

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
    return InkWell(
      onTap: () async {
        showCartDialog(
          context,
          widget.cartItem,
          _itemCount,
          widget.recountTotal,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "images/${widget.cartItem.menu.filename}",
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cartItem.menu.name),
                  Text(
                    formatToRupiah(
                      widget.cartItem.menu.price * widget.cartItem.count,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text("${widget.cartItem.count}"),
        ],
      ),
    );
  }

  Future<void> showCartDialog(
    BuildContext context,
    CartItem cartItem,
    int count,
    recountTotal,
  ) {
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
                child: Image.asset("images/${cartItem.menu.filename}"),
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
                      cartItem.menu.name,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      formatToRupiah(cartItem.menu.price),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                CartDialogState(
                  price: cartItem.menu.price,
                  id: cartItem.id,
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
                Provider.of<CartProvider>(context, listen: false)
                    .deleteCartItem(widget.cartItem.id);
                recountTotal();
                Navigator.of(dialogContext).pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red[800]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.red[800]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .updateCartItemCount(cartItem.menu.id, _itemCount);
                recountTotal();
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Ubah",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
