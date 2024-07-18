import 'package:flutter/material.dart';
import 'package:nacho_cafe/pages/cart_page.dart';
import 'package:nacho_cafe/pages/front_page.dart';
import 'package:nacho_cafe/pages/home_page.dart';
import 'package:nacho_cafe/pages/search_page.dart';
import 'package:nacho_cafe/pages/splash_screen.dart';

Route animatedPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

const splashScreenRoute = "splashScreen";
const frontPageRoute = "front";
const homePageRoute = "home";
const searchPageRoute = "search";
const cartPageRoute = "cart";

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case splashScreenRoute:
      return animatedPageBuilder(const SplashScreen());
    case frontPageRoute:
      return animatedPageBuilder(const FrontPage());
    case homePageRoute:
      return animatedPageBuilder(const HomePage());
    case searchPageRoute:
      return animatedPageBuilder(const SearchPage());
    case cartPageRoute:
      return animatedPageBuilder(const CartPage());
    default:
      return animatedPageBuilder(
          const Placeholder(child: Center(child: Text("Unimplemented"))));
  }
}
