import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../Models/Cart.dart';
import '../Models/Product.dart';
import '../Models/openMap.dart';
import '../Provider/cart_provider.dart';
import '../Provider/customer_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({required this.product, this.isCart, Key? key})
      : super(key: key);

  Product product;
  Cart? isCart;
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int count = 1;
  double mapHeight = 150.0, lat = 0.0, lng = 0.0;

  final CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 15);

  late GoogleMapController _controller;
  final List<Marker> markers = <Marker>[
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.5204, 74.3587),
    )
  ];
  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    var tempPharmacy = pharmacyProvider.pharmacyList
        .firstWhere((pharmacy) => pharmacy.id == widget.product.pharmacyId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyCartScreen()));
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: 230,
                      child: Image.network(
                        widget.product.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.visible),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (count > 1) count--;
                          setState(() {});
                        },
                        child: Container(
                            color: Colors.blue,
                            height: 35,
                            width: 35,
                            child: const Icon(
                              CupertinoIcons.minus,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        color: Colors.white,
                        height: 35,
                        width: 35,
                        child: Center(
                            child: Text(
                          '$count',
                          style: const TextStyle(fontSize: 24),
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          count++;
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.blue,
                          height: 35,
                          width: 35,
                          child: const Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.product.sellPrice} Pkr per Item',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Pharmacy: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: pharmacyProvider.pharmacyList
                                .firstWhere((pharmacy) =>
                                    pharmacy.id == widget.product.pharmacyId)
                                .name,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          MapUtils.openMap(tempPharmacy.lat.toDouble(),
                              tempPharmacy.lng.toDouble());
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Direction",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                  const Text(
                    "Descreption:",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('                 ${widget.product.description}'),
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: "Dose: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "25mg",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ]),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "Category: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.product.category,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.isCart != null) {
                        } else {
                          widget.isCart = Cart(
                              id: "",
                              userId: customerProvider.currentCustomer.id,
                              pharmacyId: widget.product.pharmacyId,
                              productId: widget.product.id,
                              count: count);
                          cartProvider.addToCard(widget.isCart!);
                        }
                      },
                      child: cartProvider.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_shopping_cart_outlined),
                                widget.isCart != null
                                    ? const Icon(Icons.check)
                                    : const Text("Add to cart"),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
