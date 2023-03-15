import 'package:flutter/material.dart';

import '../wedget/app_Drawer.dart';

class UserProductScreen extends StatelessWidget {

  static const routeName='/User-Product-Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(

          child: Text("UserProductScreen")
      ),
      drawer:AppDrawer() ,

    );
  }
}
