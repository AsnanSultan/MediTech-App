import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/Cart.dart';
import 'customer_provider.dart';

class CartProvider with ChangeNotifier {
  List<Cart> cartList = [];
  bool isLoading = false;
  CustomerProvider customerProvider = CustomerProvider();

  CartProvider() {
    getCartList();
  }

  Future getCartList() async {
    cartList.clear();
    isLoading = true;
    notifyListeners();
    await customerProvider.getCurrentUser();
    try {
      var data = await FirebaseFirestore.instance.collection('Cart').get();
      List<Cart> tempList = [];

      tempList = List.from(data.docs.map((doc) => Cart.fromSnapshot(doc)));
      for (int i = 0; i < tempList.length; i++) {
        if (customerProvider.currentCustomer.id == tempList[i].userId) {
          cartList.add(tempList[i]);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
    isLoading = false;
    notifyListeners();
  }

  Future addToCard(Cart cart) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "userId": cart.userId,
        "pharmacyId": cart.pharmacyId,
        "productId": cart.productId,
        "count": cart.count
      };
      await FirebaseFirestore.instance
          .collection("Cart")
          .add(data)
          .then((value) => cart.id = value.id);
      cartList.add(cart);
      // getCartList();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something is wrong", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
    isLoading = false;
    notifyListeners();
  }

  Future deleteFromCart(Cart cart) async {
    isLoading = true;
    notifyListeners();
    await FirebaseFirestore.instance.collection('Cart').doc(cart.id).delete();
    await getCartList();
    isLoading = false;
    notifyListeners();
  }

  Future changeCount(Cart cart) async {
    Map<String, dynamic> data = {"count": cart.count};
    await FirebaseFirestore.instance
        .collection("Cart")
        .doc(cart.id)
        .update(data);
    isLoading = false;
    notifyListeners();
  }
}
