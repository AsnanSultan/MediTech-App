import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

import 'RegistrationScreens/welcome_page.dart';
import 'home.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  checkLogin() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      try {
        await Firebase.initializeApp().whenComplete(() {
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
            if (user != null) {
              var _instance = FirebaseFirestore.instance;
              bool flag = (await _instance
                          .collection("Customers")
                          .where("id", isEqualTo: user.uid)
                          .get())
                      .size >
                  0;
              if (flag == true) {
                setState(() {});
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              }
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            }
          });
        });
      } catch (e) {
        print(e);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => WelcomePage(),
        ));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent.withOpacity(.2),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Shimmer.fromColors(
            baseColor: Colors.blueAccent,
            highlightColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/MT_logo.png',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                const Text(
                  "Medi-Tech",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
