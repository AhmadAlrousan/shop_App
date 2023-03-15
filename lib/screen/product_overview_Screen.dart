import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../wedget/app_Drawer.dart';
import '../wedget/badge.dart';
import '../wedget/products_grid.dart';
import './cart_Screen.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorites = false;
  // var _isUnit=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    Provider.of<Products>(context, listen: false).fetchAndSetProduct().then(
          (_) => setState(() => _isLoading = false),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("only Favorites "),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text("show all "),
                value: FilterOption.Favorites,
              )
            ],
            onSelected: (FilterOption selectedVal) {
              setState(() {
                if (selectedVal == FilterOption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          // Consumer<Cart>(
          //   builder: (_, cart, ch) => Badge(
          //     child: ch,
          //     value: cart.itemCount.toString(),
          //   ),
          //   child: IconButton(
          //       onPressed: () =>
          //           Navigator.of(context).pushNamed(CartScreen.routeName),
          //       icon: Icon(Icons.shopping_cart)),
          // )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites, showFavs: false,),
      drawer: AppDrawer(),
    );
  }
}
