import 'package:flutter/material.dart';
import 'package:nacho_cafe/core/local_repository.dart';
import 'package:nacho_cafe/states/cart_provider.dart';
import 'package:nacho_cafe/states/menu_provider.dart';
import 'package:nacho_cafe/utils/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuProvider(
            localRepository: const LocalRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(
            localRepository: const LocalRepository(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nacho Cafe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: splashScreenRoute,
      onGenerateRoute: routes,
    );
  }
}
