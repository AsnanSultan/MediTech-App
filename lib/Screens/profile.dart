import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:medi_tech/Screens/Settings/rate_us.dart';
import 'package:medi_tech/Screens/user_edit.dart';
import 'package:medi_tech/Widgets/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../Widgets/my_setting_row.dart';
import 'RegistrationScreens/signin_page.dart';
import 'Settings/chat_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: const Color(0xffE7E7E8),
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomBar(
        currentIndex: 3,
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                "My Profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                /* height: MediaQuery.of(context).size.height-162,
                width: MediaQuery.of(context).size.width,*/
                color: const Color(0xffFFFFFF),
                padding: const EdgeInsets.all(12.0),
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 400.0,
                        verticalOffset: -200,
                        delay: const Duration(milliseconds: 120),
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        customerProvider.isLoading
                            ? SizedBox(
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue,
                                    backgroundImage: AssetImage(
                                      "assets/images/UserIcon.png",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customerProvider.currentCustomer.name,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          '+92 ${customerProvider.currentCustomer.phone}'),
                                      Text(customerProvider
                                          .currentCustomer.email),
                                    ],
                                  ),
                                  const Expanded(
                                      child: SizedBox(
                                    height: 1,
                                  )),
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        MySettingRow(Icons.settings, "General Settings", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserEditScreen(
                                      customer:
                                          customerProvider.currentCustomer)));
                        }),
                        MySettingRow(
                          Icons.headset_mic_rounded,
                          "Need Help",
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Chat()));
                          },
                        ),
                        /*MySettingRow(
                            Icons.notifications_active_sharp, "Notifications",
                            () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen()));
                        }),*/
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
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                              (route) => false);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
