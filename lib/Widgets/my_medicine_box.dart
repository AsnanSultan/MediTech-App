import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medi_tech/Models/Cart.dart';
import 'package:medi_tech/Models/Pharmacy.dart';
import 'package:medi_tech/Models/Product.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_provider.dart';
import '../Screens/product_details_screen.dart';

class MyMedicineBox extends StatefulWidget {
  MyMedicineBox({required this.product, this.isCart, Key? key})
      : super(key: key);

  Product product;
  Cart? isCart;

  @override
  State<MyMedicineBox> createState() => _MyMedicineBoxState();
}

class _MyMedicineBoxState extends State<MyMedicineBox> {
  List<bool> rating = [true, false, false, false, false];

  void setRating(int count) {
    for (int i = 0; i < 5; i++) {
      if (i < count) {
        rating[i] = true;
      } else {
        rating[i] = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    Pharmacy pharmacy = pharmacyProvider.pharmacyList
        .firstWhere((pharmacy) => pharmacy.id == widget.product.pharmacyId);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      product: widget.product,
                      isCart: widget.isCart,
                    )));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 35.0),
                      width: 70,
                      height: 90,
                      child: Image.network(widget.product.imagePath)),
                  Container(
                    width: 50,
                    height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.lightBlueAccent,
                    ),
                    child: const Center(child: Text('New')),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.product.sellPrice}PKr',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      pharmacy.name,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 11),
                    ),
                  ),
                  Text(
                    '${((Geolocator.distanceBetween(customerProvider.currentCustomer.lat.toDouble(), customerProvider.currentCustomer.lng.toDouble(), pharmacy.lat.toDouble(), pharmacy.lng.toDouble())) / 1000).toStringAsFixed(2)}KM',
                    style: const TextStyle(fontSize: 16),
                  ),
                  /* Row(
                    children: [
                      Container(
                        width: 120,
                        height: 30,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: rating.length,
                            itemBuilder: (context, index) {
                              return Icon(
                                index == 4 ? Icons.star_half : Icons.star,
                                color: Colors.yellow,
                              );
                            }),
                      ),
                      Text('(${4.1})'),
                    ],
                  ),*/
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: 4.3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 22,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const Text('(${1})'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
