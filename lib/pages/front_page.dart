import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/utils/routes.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 24.0),
            Text(
              "Pilih Pesanan",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            OptionType(
              iconUrl: "images/ic_food.svg",
              label: "Makanan",
              pageRoute: homePageRoute,
            ),
            SizedBox(height: 16.0),
            OptionType(
              iconUrl: "images/ic_drink.svg",
              label: "Minuman",
              pageRoute: homePageRoute,
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

class OptionType extends StatelessWidget {
  const OptionType({
    super.key,
    required this.label,
    required this.iconUrl,
    required this.pageRoute,
  });

  final String label;
  final String iconUrl;
  final String pageRoute;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, pageRoute);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 48.0,
          horizontal: 56.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              iconUrl,
              width: 64.0,
              height: 64.0,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
