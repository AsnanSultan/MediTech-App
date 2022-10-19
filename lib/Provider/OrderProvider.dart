import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medi_tech/Provider/cart_provider.dart';

import '../Models/Cart.dart';
import '../Models/Order.dart';
import 'customer_provider.dart';

class OrderProvider with ChangeNotifier {
  List<Order> orderList = [];
  bool isLoading = false;
  CustomerProvider customerProvider = CustomerProvider();
  CartProvider cartProvider = CartProvider();

  OrderProvider() {
    getOrderList();
  }

  Future getOrderList() async {
    orderList.clear();
    isLoading = true;
    notifyListeners();
    await customerProvider.getCurrentUser();
    // try {
    var data = await FirebaseFirestore.instance
        .collection('Orders')
        .where("userId", isEqualTo: customerProvider.currentCustomer.id)
        .get();
    List<Order> tempList = [];

    tempList = List.from(data.docs.map((doc) => Order.fromSnapshot(doc)));

    List<Cart> tempCartList = [];
    int count = 0;
    for (var element in data.docs) {
      tempCartList = [];
      var tempData = element.data()['products'];
      for (int i = 0; i < tempData.length; i++) {
        var temp3 = tempData['product$i'];
        tempCartList.add(Cart.fromMap(temp3));
      }
      tempList[count].cartList.addAll(tempCartList);
      orderList.add(tempList[count]);
      count++;
    }

    isLoading = false;
    notifyListeners();
  }

  Future addOrder(Order order) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> productsMap = {};

      for (int i = 0; i < order.cartList.length; i++) {
        productsMap['product$i'] = (order.cartList[i].toMap());
      }
      Map<String, dynamic> data = {
        "products": productsMap,
        "userId": order.userId,
        "lat": order.lat,
        "lng": order.lng,
        "contactInfo": order.contactInfo,
        "dateTime": order.dateTime,
        "isPayNow": order.isPayNow,
        "isCompleted": order.isCompleted,
      };
      await FirebaseFirestore.instance
          .collection("Orders")
          .add(data)
          .then((value) => order.orderId = value.id);
      orderList.add(order);
      /*  for (int i = 0; i < cartProvider.cartList.length; i++) {
        await cartProvider.deleteFromCart(cartProvider.cartList[i]);
      }*/
      isLoading = false;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something is wrong", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent, // location
          timeInSecForIosWeb: 1 // duration
          );
      print(e);
    }
  }

  /* Future deleteOrder(Order order) async {
    isLoading = true;
    notifyListeners();
    await FirebaseFirestore.instance.collection('Cart/').doc(order.id).delete();
    Fluttertoast.showToast(
        msg: "Removed From Cart", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueAccent, // location
        timeInSecForIosWeb: 1 // duration
        );
    orderList.removeWhere((temp) => temp.id == order.id);
    //getCartList();
    isLoading = false;
    notifyListeners();
  }*/

}
