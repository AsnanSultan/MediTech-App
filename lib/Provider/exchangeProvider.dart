import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medi_tech/Models/Exchange.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:provider/provider.dart';

class ExchangeProvider with ChangeNotifier {
  bool isLoading = false;
  List<Exchange> exchangeList = [];
  CustomerProvider customerProvider = CustomerProvider();
  ExchangeProvider() {
    getReturnExchangeList();
  }
  Future requestReturnExchange(Exchange exchangeProduct, File receipt) async {
    isLoading = true;
    notifyListeners();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'returnExchangeReceipt/${exchangeProduct.pharmacyId}/${receipt.path.hashCode}');

    firebase_storage.UploadTask uploadTask = ref.putFile(receipt);
    String url = "";

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    url = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> data = {
      "productId": exchangeProduct.productId,
      "pharmacyId": exchangeProduct.pharmacyId,
      "customerId": exchangeProduct.customerId,
      "reason": exchangeProduct.reason,
      "status": exchangeProduct.status,
      "count": exchangeProduct.count,
      "receipt": url,
    };
    await FirebaseFirestore.instance.collection("Return_Exchange").add(data);
    isLoading = false;
    notifyListeners();
  }

  Future<List<Exchange>> getReturnExchangeList() async {
    exchangeList.clear();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var data = await FirebaseFirestore.instance
          .collection('Return_Exchange')
          .where('customerId', isEqualTo: user!.uid)
          .get();
      List<Exchange> tempList = [];

      tempList = List.from(data.docs.map((doc) => Exchange.fromSnapshot(doc)));

      exchangeList.addAll(tempList);
      return exchangeList;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
      return exchangeList;
    }
  }
}
