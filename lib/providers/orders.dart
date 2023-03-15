import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  getData(String getAuthToken, String uId, List<OrderItem> orders) {
    authToken = getAuthToken;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get items {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-88d6f-default-rtdb.firebaseio.com/orders/$userId.json'; // ?auth=$authToken

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quntity: item["quntity"],
                  price: item["price"]))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }


  Future<void> addOrder(List<CartItem> cartProduct , double total ) async {
    final url = 'https://shop-88d6f-default-rtdb.firebaseio.com/orders/$userId.json'; //?auth=$authToken

    try {
      final timestamp=DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProduct.map((cp) => {
              'id' : cp.id,
              'title' : cp.title,
              'quntity' : cp.quntity,
              'price' : cp.price,
            }).toList(),
          }));
      _orders.insert(0, OrderItem(id: json.decode(res.body)['name'], amount: total, products: cartProduct, dateTime: timestamp));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
