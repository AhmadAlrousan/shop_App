import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app_00/providers/auth.dart';
import 'package:shop_app_00/providers/cart.dart';
import 'package:shop_app_00/providers/orders.dart';
import 'package:shop_app_00/screen/cart_Screen.dart';
import 'package:shop_app_00/screen/edit_Product_Screen.dart';
import 'package:shop_app_00/screen/order_screen.dart';
import 'package:shop_app_00/screen/product_detail_Screen.dart';
import 'package:shop_app_00/screen/product_overview_Screen.dart';
import 'package:shop_app_00/screen/user_Products_Screen.dart';
import './screen/auth_Screen.dart';
import 'providers/products.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),

        ChangeNotifierProxyProvider<Auth, Order>(
          create: (_) => Order(),
          update: (ctx, authVal, previousOrder) => previousOrder
            ..getData(authVal.token, authVal.userId,previousOrder==null? null : previousOrder.items),
        ),

      //  ChangeNotifierProvider.value(value: Order()),


        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authVal, previousProducts) => previousProducts
            ..getData(authVal.token, authVal.userId,previousProducts==null? null : previousProducts.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
          ),
          home: ProductOverviewScreen(),
          // auth.isAuth
          //     ? ProductOverviewScreen()
          //     : FutureBuilder(
          //         future: auth.tryAutoLogin(),
          //         builder: (ctx, AsyncSnapshot authSnapshot) =>
          //             authSnapshot.connectionState == ConnectionState.waiting
          //                 ? SplashScreen()
          //                 : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            AuthScreen.routeName: (_) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
