import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nacho_cafe/pages/widgets/item_widget.dart';
import 'package:nacho_cafe/states/menu_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
            onTap: () {},
            child: SvgPicture.asset(
              "images/ic_search.svg",
              width: 28.0,
              height: 28.0,
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Column(
            children: [
              TextField(
                onChanged: (String newValue) {
                  Provider.of<MenuProvider>(
                    context,
                    listen: false,
                  ).search(newValue);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        height: 32.0,
                        "images/ic_search.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Consumer<MenuProvider>(
                builder: (context, value, child) {
                  if (value.searchState == SearchState.idle) {
                    return const Center(child: Text("Idle"));
                  } else if (value.searchState == SearchState.loading) {
                    return const Center(child: Text("Loading"));
                  } else if (value.searchState == SearchState.noItem) {
                    return const Center(child: Text("No Item"));
                  } else if (value.searchState == SearchState.hasItem) {
                    return GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        value.searchMenus.length,
                        (int index) {
                          return ItemWidget(
                            width: double.infinity,
                            height: double.infinity,
                            name: value.searchMenus[index].name,
                            nameFontSize: 16.0,
                            price: value.searchMenus[index].price,
                            priceFontSize: 14.0,
                            imageUrl:
                                "images/${value.searchMenus[index].filename}",
                          );
                        },
                      ),
                    );
                  } else {
                    throw "Unreachable code";
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
