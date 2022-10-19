import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:medi_tech/Screens/Settings/rate_us.dart';
import 'package:medi_tech/Screens/order_list_screen.dart';
import 'package:provider/provider.dart';

import '../Screens/CustomOrder/custom_order_screen.dart';
import '../Screens/RegistrationScreens/signin_page.dart';
import '../Screens/Return/Exchange/exchangeProductScreen.dart';
import '../Screens/Settings/chat_screen.dart';
import 'my_setting_row.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Medi-Tech App',
      text: 'Medi-Tech App',
      linkUrl: 'Application link will be added latter',
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    return Container(
      color: const Color(0xffFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xff00C0FF),
            padding: const EdgeInsets.only(
                top: 60.0, left: 2, right: 12, bottom: 10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: AssetImage(
                    "assets/images/UserIcon.png",
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Text(
                        customerProvider.currentCustomer.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('+92 ${customerProvider.currentCustomer.phone}'),
                    SizedBox(
                      width: 160,
                      child: Text(
                        customerProvider.currentCustomer.email,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                /*Expanded(
                    child: SizedBox(
                  height: 1,
                )),*/
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                MySettingRow(Icons.shopping_bag, "Orders", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderListScreen()));
                }),
                MySettingRow(Icons.dashboard_customize, "Custom Orders", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomOrderScreen()));
                }),
                MySettingRow(Icons.repeat, "Return/Exchange", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ExchangeProductsScreen()));
                }),
                MySettingRow(
                  Icons.headset_mic_rounded,
                  "Need Help",
                  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Chat()));
                  },
                ),
                MySettingRow(Icons.share, "Share App", () {
                  share();
                }),
                MySettingRow(Icons.star_rate, "Rate Us", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RateUsScreen()));
                }),
                MySettingRow(Icons.logout, "Logout", () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                      (route) => false);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
