import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Models/Customer.dart';

class CustomerProvider with ChangeNotifier {
  late Customer currentCustomer;
  bool isLoading = false;
  CustomerProvider() {
    currentCustomer =
        Customer(id: "", name: "", email: "", phone: "", lng: 0, lat: 0);
    getCurrentUser();
  }
  Future getCurrentUser() async {
    isLoading = true;
    notifyListeners();
    User? user = FirebaseAuth.instance.currentUser;
    var data = await FirebaseFirestore.instance
        .collection("Customers")
        .doc(user?.uid)
        .get();
    currentCustomer = Customer.fromSnapshot(data);
    isLoading = false;
    notifyListeners();
  }
}
