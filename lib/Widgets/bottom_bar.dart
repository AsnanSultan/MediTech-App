import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_tech/Screens/home.dart';
import 'package:medi_tech/Screens/map.dart';
import 'package:medi_tech/Screens/profile.dart';

import '../Screens/cart_screen.dart';

class MyBottomBar extends StatelessWidget {
  final int currentIndex;
  const MyBottomBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(top: 8),
      //margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.house_alt,
              ),
              label: "Home",
              tooltip: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.location_on_outlined,
              ),
              label: "Map",
              tooltip: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: "Cart",
              tooltip: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: "Profile",
              tooltip: "Profile",
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            }
            if (index == 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyMapScreen()),
                  (route) => false);
            }
            if (index == 2) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCartScreen()),
                  (route) => false);
            }
            if (index == 3) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyProfileScreen()),
                  (route) => false);
            }
          },
        ),
      ),
    );
  }
}
