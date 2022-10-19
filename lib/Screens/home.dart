import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import 'package:medi_tech/Screens/serachScreen.dart';

import 'package:medi_tech/Widgets/banner.dart';
import 'package:medi_tech/Widgets/bottom_bar.dart';
import 'package:medi_tech/Widgets/service_box.dart';

import '../Covid_19/View/world_states.dart';
import '../Widgets/my_drawer.dart';
import 'all_product_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    /* animationController =
        AnimationController(vsync: this, duration: const Duration(hours: 1));*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MediTech"),
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
      bottomNavigationBar: const MyBottomBar(
        currentIndex: 0,
      ),
      backgroundColor: const Color(0xffE7E7E8),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: AnimationLimiter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 400.0,
                  verticalOffset: -50,
                  delay: const Duration(milliseconds: 200),
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MySearchScreen()));
                    },
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Search Medicine...",
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              height: 1,
                              color: Colors.black,
                            )
                          ],
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: ListView(children: [
                      CarouselSlider(
                        items: const [
                          MyBanner(
                              image: "assets/images/MediTechBannerAd0.png",
                              bgColor: Color(0xff060A0E),
                              text: ""),
                          MyBanner(
                              image: "assets/images/MediTechBannerAd1.png",
                              bgColor: Colors.amberAccent,
                              text: ""),
                          MyBanner(
                              image: "assets/images/MediTechBannerAd0.png",
                              bgColor: Colors.blueAccent,
                              text: ""),
                          MyBanner(
                              image: "assets/images/MediTechBannerAd1.png",
                              bgColor: Colors.red,
                              text: ""),
                        ],
                        options: CarouselOptions(
                          height: 120.0,

                          enlargeCenterPage: true,
                          autoPlay: true,
                          // aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          //  viewportFraction: 0.8,
                        ),
                      ),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 12),
                    child: Text("Category"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Tablets",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                          image: 'assets/images/tabletImage.jfif',
                          text: "Tablets",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Capsules",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                            image: 'assets/images/capsuleImage.png',
                            text: "Capsules"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Syrup",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                            image: 'assets/images/syrupImage.jpg',
                            text: "Syrup"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Injections",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                            image: 'assets/images/injectionImage.jpg',
                            text: "Injections"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Drops",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                            image: 'assets/images/dropsImage.jpg',
                            text: "Drops"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Homeopathic",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                            image: 'assets/images/homeopathic.jpg',
                            text: "Homeopathic"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen(
                                        filter: "Medical Equipments",
                                        isHome: false,
                                      )));
                        },
                        child: const ServiceBox(
                            image: 'assets/images/medicalEquipmentImage.jpg',
                            text: "Medical Equipments"),
                      ),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const WorldStates())),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ]),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Lottie.asset(
                        "assets/covid.json",
                        // reverse: true,
                        repeat: true,
                        /*controller: animationController,
                          onLoaded: (composition) {
                        animationController.duration = composition.duration;
                        animationController.forward();
                      }*/
                      ),
                      /* ListView(scrollDirection: Axis.horizontal, children: [
                        MyArticalBox(
                          image: 'assets/images/LumigenexBrand.png',
                        ),
                        MyArticalBox(
                          image: 'assets/images/maskBrand.png',
                        ),
                        MyArticalBox(
                          image: 'assets/images/medicBrand.png',
                        ),
                      ]),*/
                    ),
                  ),
                  AllProductScreen(
                    filter: "All",
                    isHome: true,
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
