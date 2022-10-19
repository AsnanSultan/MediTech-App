import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medi_tech/Screens/RegistrationScreens/signin_page.dart';

import '../../Widgets/my_text_button.dart';
import '../../constants.dart';
import '../home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  String email = "", password = "";
  String name = "", number = "";
  bool isLoading = false;
  TextEditingController addressController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;
  String address = "";
  bool isLocationLoading = false;
  //int isGetLocation = 0;

  late StreamSubscription<Position> streamSubscription;
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
        getAddressFromLatLang(position).whenComplete(() {
          streamSubscription.cancel();

          isLocationLoading = false;
          setState(() {});
        });
      });
    } on Exception {
      print("Error1");
    }
  }

  Future<void> getAddressFromLatLang(Position position) async {
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemark[0];

      address =
          '${place.street},${place.locality}, ${place.administrativeArea},  ${place.country}';
      addressController.text = address;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Please Check you network", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
  }

  Future<void> createUser(var uid) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection("Customers").doc(uid).set({
        "id": uid,
        "name": name,
        "email": email,
        "number": number,
        "lat": latitude,
        "lng": longitude,
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something is wrong", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
  }

  void registerUser() async {
    isLoading = true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      createUser(userCredential.user?.uid).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak.", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER, // location
            timeInSecForIosWeb: 1 // duration
            );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blueAccent, // location
            timeInSecForIosWeb: 1 // duration
            );
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
    isLoading = false;
    setState(() {});
  }

  String errorMessage = '';
  void validateEmail(String val) {
    errorMessage = '';
    if (val.isEmpty) {
      setState(() {
        errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, false, true)) {
      setState(() {
        errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Image(
            width: 24,
            color: Colors.blue,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Register",
                            style: kHeadline,
                          ),
                          const Text(
                            "Create new account to get started.",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  onChanged: (val) {
                                    name = val;
                                    setState(() {});
                                  },
                                  style: kBodyText.copyWith(color: Colors.blue),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    labelText: "Name",
                                    hintText: "Name",
                                    hintStyle: kBodyText,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: (name == "")
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                                if (name == "")
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Name can not be empty",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  onChanged: (val) {
                                    email = val;
                                    validateEmail(val);
                                  },
                                  style: kBodyText.copyWith(color: Colors.blue),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    labelText: "Email",
                                    hintText: "Email",
                                    hintStyle: kBodyText,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: errorMessage == ''
                                            ? Colors.blue
                                            : Colors.red,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                                if (errorMessage != '')
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  onChanged: (val) {
                                    number = val;
                                    setState(() {});
                                  },
                                  style: kBodyText.copyWith(color: Colors.blue),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    labelText: "Phone",
                                    hintText: "Phone",
                                    hintStyle: kBodyText,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: (number == "")
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                                if (number == "")
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Phone can not be empty",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            //width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 270,
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextField(
                                        controller: addressController,
                                        style: kBodyText.copyWith(
                                            color: Colors.blue),
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
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  (addressController.text == "")
                                                      ? Colors.red
                                                      : Colors.blue,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(18),
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
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                if (addressController.text == "")
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Address can not be empty",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  onChanged: (val) {
                                    password = val;
                                    setState(() {});
                                  },
                                  style: kBodyText.copyWith(
                                    color: Colors.blue,
                                  ),
                                  obscureText: passwordVisibility,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            passwordVisibility =
                                                !passwordVisibility;
                                          });
                                        },
                                        icon: Icon(
                                          passwordVisibility
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                    hintText: 'Password',
                                    hintStyle: kBodyText,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: (password == "")
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                                if (password == "")
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Password can not be empty",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: kBodyText.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: () {
                        registerUser();
                      },
                      bgColor: Colors.blue,
                      textColor: Colors.white,
                      isLoading: isLoading,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
