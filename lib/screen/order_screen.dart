import 'package:flutter/material.dart';

import '../wedget/app_Drawer.dart';

class OrderScreen extends StatelessWidget {

  static const routeName='/Order-Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(

          child: Text("OrderScreen")
      ),
      drawer:AppDrawer() ,

    );;
  }
}
