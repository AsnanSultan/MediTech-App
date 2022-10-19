import 'package:flutter/cupertino.dart';
import 'package:medi_tech/Models/Pharmacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Product.dart';

class PharmacyProvider with ChangeNotifier {
  List<Pharmacy> pharmacyList = [];
  List<Product> productList = [];
  bool isLoading = false;

  PharmacyProvider() {
    getData();
  }
  void getData() async {
    isLoading = true;
    notifyListeners();
    await getProductList();
    isLoading = false;
    notifyListeners();
  }

  Future getPharmacyList() async {
    pharmacyList.clear();
    productList.clear();
    try {
      var data =
          await FirebaseFirestore.instance.collection("Pharmacies").get();

      pharmacyList =
          List.from(data.docs.map((doc) => Pharmacy.fromSnapshot(doc)));
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
  }

  Future getProductList() async {
    await getPharmacyList();
    String uid = '';
    for (int i = 0; i < pharmacyList.length; i++) {
      uid = pharmacyList[i].id;

      try {
        var data = await FirebaseFirestore.instance
            .collection('Pharmacies/$uid/Products')
            .get();
        List<Product> tempList = [];

        tempList = List.from(data.docs.map((doc) => Product.fromSnapshot(doc)));
        pharmacyList[i].products.addAll(tempList);
        productList.addAll(tempList);
      } catch (e) {
        Fluttertoast.showToast(
            msg:
                "Something wrong please check your internet connection", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER, // location
            timeInSecForIosWeb: 1 // duration
            );
      }
    }
  }

  Product getProductFromId(String id) {
    return productList.firstWhere((element) => element.id == id);
  }

  Pharmacy getPharmacyFromId(String id) {
    return pharmacyList.firstWhere((element) => element.id == id);
  }
}
