import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
   bool isFavorite;

  Product({required this.id, required this.title,required  this.description,
      required  this.imageUrl, required this.price,required this.isFavorite,   });

  void _setFavValue(bool newValue){
    isFavorite=newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async{
    final oldStatus=isFavorite;
    isFavorite=!isFavorite;
    notifyListeners();

    final url ="https://shop-88d6f-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json";
    try{
     final res= await http.put(
        url,
        body: json.encode(isFavorite)
      );
     if(res.statusCode >= 400){
      _setFavValue(oldStatus);
     }
    }catch(e){
      _setFavValue(oldStatus);
    }

  }

}
