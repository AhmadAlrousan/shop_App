import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({Key? key, required this.child, required this.value,required this.color})
      : super(key: key);
  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            child: Text(value, style: TextStyle(fontSize: 10,),),
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color != null ? color : Theme.of(context).primaryColor),
            constraints:BoxConstraints(minHeight: 16 , maxWidth: 16 ,) ,

          ),
        )
      ],
    );
  }
}
