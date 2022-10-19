import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:medi_tech/Models/Order.dart';
import 'package:medi_tech/Provider/OrderProvider.dart';
import 'package:medi_tech/Provider/cart_provider.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:medi_tech/Screens/home.dart';
import 'package:provider/provider.dart';

import '../../Models/Customer.dart';
import '../../Widgets/my_text_button.dart';
import '../../constants.dart';

class PlaceOrderScreen extends StatefulWidget {
  PlaceOrderScreen(
      {required this.subtotal,
      required this.discount,
      required this.total,
      required this.customer,
      Key? key})
      : super(key: key);

  double subtotal;
  double discount;
  double total;
  Customer customer;

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool contactInfoFlag = true;
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNode2 = FocusNode();
  double latitude = 0.0;
  double longitude = 0.0;
  String address = "";
  bool isLocationLoading = false;

  late StreamSubscription<Position> streamSubscription;
  late AnimationController animationController;

  getLocation() async {
    try {
      isLocationLoading = true;
      setState(() {});
      bool sericeEnabled = false;
      LocationPermission permission;
      sericeEnabled = await Geolocator.isLocationServiceEnabled();
      if (!sericeEnabled) {
        await Geolocator.openLocationSettings();
        Fluttertoast.showToast(
            msg: "Location service are disabled.",
            // message
            toastLength: Toast.LENGTH_SHORT,
            // length
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blueAccent,
            // location
            timeInSecForIosWeb: 1 // duration
            );
        isLocationLoading = false;
        setState(() {});
        return 0;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        isLocationLoading = false;
        setState(() {});
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(
              msg: "Location permissions are denied",
              // message
              toastLength: Toast.LENGTH_SHORT,
              // length
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueAccent,
              // location
              timeInSecForIosWeb: 1 // duration
              );
          return 0;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Fluttertoast.showToast(
            msg:
                "Location permissions are permanently denied, we cannot request permissions.",
            // message
            toastLength: Toast.LENGTH_SHORT,
            // length
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blueAccent,
            // location
            timeInSecForIosWeb: 1 // duration
            );
        return 0;
      }

      streamSubscription =
          Geolocator.getPositionStream().listen((Position position) {
        latitude = position.latitude;
        longitude = position.longitude;
        getAddressFromLatLang().whenComplete(() {
          streamSubscription.cancel();

          isLocationLoading = false;
          setState(() {});
        });
      });
    } on Exception {
      print("Error1");
    }
  }

  Future<void> getAddressFromLatLang() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemark[0];
    address =
        '${place.street},${place.locality}, ${place.administrativeArea},  ${place.country}';
    addressController.text = address;
  }

  void showConfirmDialog() => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/confirm_order.json",
                    repeat: false,
                    controller: animationController, onLoaded: (composition) {
                  animationController.duration = composition.duration;
                  animationController.forward();
                }),
                const Text(
                  "Order Confirm",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ));

  void confirmOrder() {}

  @override
  void initState() {
    // TODO: implement initState
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        animationController.reset();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }
    });

    latitude = widget.customer.lat.toDouble();
    longitude = widget.customer.lng.toDouble();
    print('lat: $latitude');

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    myFocusNode2.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    getAddressFromLatLang();
    phoneNumberController.text = customerProvider.currentCustomer.phone;
    emailController.text = customerProvider.currentCustomer.email;
    addressController.text = address;
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Order"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 400.0,
                  verticalOffset: -50,
                  delay: const Duration(milliseconds: 100),
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  const Text(
                    "Delivery Address",
                    style: TextStyle(fontSize: 32),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    //width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: addressController,
                            style: kBodyText.copyWith(color: Colors.blue),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: "Address",
                              contentPadding: const EdgeInsets.all(20),
                              hintText: "Address",
                              hintStyle: kBodyText,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        isLocationLoading
                            ? Container(
                                child: const CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  getLocation();
                                },
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    Text(
                                      "Current\nLocation",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  const Text(
                    "Contact Information",
                    style: TextStyle(fontSize: 32),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 290,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: phoneNumberController,

                          onTap: () {
                            contactInfoFlag = true;
                            setState(() {});
                          },
                          focusNode: myFocusNode,
                          enableInteractiveSelection:
                              false, // will disable paste operation
                          readOnly: true,
                          style: kBodyText.copyWith(
                              color:
                                  contactInfoFlag ? Colors.blue : Colors.grey),
                          keyboardType: TextInputType.phone,
                          maxLines: 1,

                          //textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                                color: contactInfoFlag
                                    ? Colors.blue
                                    : Colors.grey),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),

                            /*enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: contactInfoFlag ? Colors.blue : Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),*/
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          contactInfoFlag = true;
                          myFocusNode.requestFocus();
                          myFocusNode2.unfocus();

                          myFocusNode.requestFocus();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.check_circle,
                          color: contactInfoFlag ? Colors.blue : Colors.grey,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 290,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: emailController,

                          onTap: () {
                            contactInfoFlag = false;
                            setState(() {});
                          },
                          focusNode: myFocusNode2,
                          enableInteractiveSelection:
                              false, // will disable paste operation
                          readOnly: true,
                          style: kBodyText.copyWith(
                              color:
                                  contactInfoFlag ? Colors.grey : Colors.blue),
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          //textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: contactInfoFlag
                                    ? Colors.grey
                                    : Colors.blue),
                            contentPadding: const EdgeInsets.all(20),
                            hintText: "Email",
                            hintStyle: kBodyText,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    contactInfoFlag ? Colors.grey : Colors.blue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            /*enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: contactInfoFlag ? Colors.grey : Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),*/
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          contactInfoFlag = false;
                          myFocusNode2.requestFocus();
                          myFocusNode.unfocus();
                          myFocusNode2.requestFocus();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.check_circle,
                          color: contactInfoFlag ? Colors.grey : Colors.blue,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Order Summary",
                        style: TextStyle(fontSize: 22),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 1,
                      )),
                      Text(
                        "Amount",
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Sub total:  ",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Expanded(
                          child: SizedBox(
                        height: 1,
                      )),
                      Text(
                        '${widget.subtotal}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Discount:  ",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Expanded(
                          child: SizedBox(
                        height: 1,
                      )),
                      Text(
                        '${widget.discount}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Bil:  ",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Expanded(
                          child: SizedBox(
                        height: 1,
                      )),
                      Text(
                        '${widget.total}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  /*   MyTextButton(
                    buttonName: 'Pay Now',
                    onTap: () {
                      orderProvider.getOrderList();
                    },
                    bgColor: Colors.blue,
                    textColor: Colors.white,
                    isLoading: false,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: const Center(
                      child: Text(
                        "OR",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),*/

                  MyTextButton(
                    buttonName: 'Place Order',
                    onTap: () async {
                      Order order = Order(
                          orderId: "",
                          userId: customerProvider.currentCustomer.id,
                          lat: latitude,
                          lng: longitude,
                          contactInfo: contactInfoFlag
                              ? customerProvider.currentCustomer.phone
                              : customerProvider.currentCustomer.email,
                          dateTime: DateTime.now().toString(),
                          isPayNow: false,
                          isCompleted: false,
                          cartList: cartProvider.cartList);

                      orderProvider.addOrder(order);
                      for (var element in cartProvider.cartList) {
                        Provider.of<CartProvider>(context, listen: false)
                            .deleteFromCart(element);
                      }

                      showConfirmDialog();
                    },
                    bgColor: Colors.blue,
                    textColor: Colors.white,
                    isLoading: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
