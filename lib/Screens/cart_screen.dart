import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:medi_tech/Models/Product.dart';
import 'package:medi_tech/Provider/cart_provider.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:provider/provider.dart';

import '../Provider/pharmacy_provider.dart';
import '../Widgets/bottom_bar.dart';
import '../constants.dart';
import 'CheckOutScreens/place_order_screen.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  //int count = 1;
  bool flag = false;
  double subTotal = 0;
  double total = 0;

  void _onLoading() {
    flag = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  Text("Loading..."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    subTotal = 0;
    total = 0;
    for (int i = 0; i < cartProvider.cartList.length; i++) {
      Product tempProduct = pharmacyProvider.productList.firstWhere(
          (product) => product.id == cartProvider.cartList[i].productId);
      subTotal =
          subTotal + cartProvider.cartList[i].count * tempProduct.sellPrice;
    }

    total = subTotal;
    if (flag && cartProvider.isLoading != true) {
      Navigator.pop(context);
      flag = false;
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      bottomNavigationBar: const MyBottomBar(
        currentIndex: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (!cartProvider.cartList.isNotEmpty)
                  ? Container(
                      margin: const EdgeInsets.only(top: 50, left: 13),
                      height: 300,
                      width: 300,
                      child: Column(
                        children: [
                          Image.asset('assets/images/dataNotFound.png'),
                          const Text("Data not found!"),
                        ],
                      ))
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 2.23,
                      child: StreamBuilder<QuerySnapshot>(builder:
                          (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading...");
                        }
                        return AnimationLimiter(
                          child: ListView.builder(
                              itemCount: cartProvider.cartList.length,
                              itemBuilder: (context, index) {
                                Product tempProduct = pharmacyProvider
                                    .productList
                                    .firstWhere((product) =>
                                        product.id ==
                                        cartProvider.cartList[index].productId);

                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 100.0,
                                    horizontalOffset: 100,
                                    delay: const Duration(milliseconds: 200),
                                    child: FadeInAnimation(
                                      child: MyCartBox(
                                        product: tempProduct,
                                        count:
                                            cartProvider.cartList[index].count,
                                        onPressed: () {
                                          _onLoading();
                                          cartProvider.deleteFromCart(
                                              cartProvider.cartList[index]);
                                        },
                                        onPlusPressed: () {
                                          cartProvider.cartList[index].count++;
                                          cartProvider.changeCount(
                                              cartProvider.cartList[index]);
                                        },
                                        onMinusPressed: () {
                                          if (cartProvider
                                                  .cartList[index].count >
                                              1) {
                                            cartProvider
                                                .cartList[index].count--;
                                            cartProvider.changeCount(
                                                cartProvider.cartList[index]);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                    ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextField(
                        onChanged: (val) {},
                        style: kBodyText.copyWith(color: Colors.blue),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText: "Enter Promo Code...",
                          hintStyle: kBodyText,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 47,
                      child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Apply",
                            style: TextStyle(fontSize: 16),
                          ))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Sub Total: ",
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Text(
                      'RS: $subTotal',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text(
                      "Discount: ",
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text(
                      'RS: -0.0',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Order Total: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      "RS: $total",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (cartProvider.cartList.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceOrderScreen(
                                    subtotal: subTotal,
                                    discount: 0.0,
                                    total: total,
                                    customer: customerProvider.currentCustomer,
                                  )));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Cart is empty", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.blueAccent, // location
                          timeInSecForIosWeb: 1 // duration
                          );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_outlined),
                      Text("Checkout"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyCartBox extends StatefulWidget {
  MyCartBox(
      {required this.product,
      required this.count,
      required this.onPressed,
      required this.onPlusPressed,
      required this.onMinusPressed,
      Key? key})
      : super(key: key);
  Product product;
  int count;
  VoidCallback onPressed;
  VoidCallback onPlusPressed;
  VoidCallback onMinusPressed;
  @override
  _MyCartBoxState createState() => _MyCartBoxState();
}

class _MyCartBoxState extends State<MyCartBox> {
  double price = 2.5;
  //int count = 1;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          SizedBox(
              width: 90,
              height: 120,
              child: Image.network(widget.product.imagePath)),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'price: ${widget.product.sellPrice * widget.count}',
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: widget
                        .onMinusPressed /*() {
                      if (count > 1) {
                        count--;
                      }

                      setState(() {});
                    }*/
                    ,
                    child: Container(
                        color: Colors.blue,
                        height: 30,
                        width: 30,
                        child: const Icon(CupertinoIcons.minus)),
                  ),
                  Container(
                    color: Colors.white,
                    height: 30,
                    width: 30,
                    child: Center(
                        child: Text(
                      '${widget.count}',
                      style: const TextStyle(fontSize: 24),
                    )),
                  ),
                  GestureDetector(
                    onTap: widget.onPlusPressed,
                    /*() {
                      count++;
                      setState(() {});
                    },*/
                    child: Container(
                      color: Colors.blue,
                      height: 30,
                      width: 30,
                      child: const Icon(CupertinoIcons.add),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Expanded(
              child: SizedBox(
            height: 1,
          )),
          Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 15, right: 10),
            child: IconButton(
                onPressed: widget.onPressed,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
    );
  }
}
