import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/CustomOrder.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomOrderProvider with ChangeNotifier {
  bool isLoading = false;
  List<CustomOrder> customOrderList = [];
  Future requestCustomOrder(CustomOrder customOrder, File prescription) async {
    isLoading = true;
    notifyListeners();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'CustomOrder/${customOrder.customerId}/${prescription.path.hashCode}');

    firebase_storage.UploadTask uploadTask = ref.putFile(prescription);
    String url = "";

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    url = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> data = {
      "pharmacyId": customOrder.pharmacyId,
      "customerId": customOrder.customerId,
      "instruction": customOrder.instruction,
      "status": customOrder.status,
      "prescription": url,
    };
    await FirebaseFirestore.instance.collection("CustomOrder").add(data);
    isLoading = false;
    notifyListeners();
  }

  Future<List<CustomOrder>> getCustomOrdersList() async {
    customOrderList.clear();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var data = await FirebaseFirestore.instance
          .collection('CustomOrder')
          .where('customerId', isEqualTo: user!.uid)
          .get();
      List<CustomOrder> tempList = [];

      tempList =
          List.from(data.docs.map((doc) => CustomOrder.fromSnapshot(doc)));

      customOrderList.addAll(tempList);
      return customOrderList;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
      return customOrderList;
    }
  }
}
