import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(
          context,
          frontPageRoute,
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'images/ic_brand.svg',
              width: 92.0,
              height: 92.0,
              semanticsLabel: 'brand logo',
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
            ),
            const Text(
              "Nacho Cafe",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
