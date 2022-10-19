import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/Customer.dart';
import '../Models/Pharmacy.dart';
import '../Provider/customer_provider.dart';

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({Key? key}) : super(key: key);

  @override
  State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  late GoogleMapController _controller;
  final CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 12);
  final List<Marker> markers = [];
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  bool isLoading = false;
  Position? currentPosition;
  getCurrentLocation() async {
    isLoading = true;
    setState(() {});
    currentPosition = await Geolocator.getCurrentPosition();
    print("current position is finded");
    isLoading = false;
    setState(() {});
  }

  addMarker(List<Pharmacy> pharmacyList, Customer customer) {
    for (int i = 0; i < pharmacyList.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('$i'),
          position: LatLng(
              pharmacyList[i].lat.toDouble(), pharmacyList[i].lng.toDouble()),
          onTap: () {
            CameraPosition cameraPosition = CameraPosition(
                target: LatLng(pharmacyList[i].lat.toDouble(),
                    pharmacyList[i].lng.toDouble()),
                zoom: 15);

            _controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            customInfoWindowController.addInfoWindow!(
              Container(
                height: 250,
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      width: 270,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/pharmacy.png'),
                        fit: BoxFit.fill,
                      )),
                    ),
                    Text(
                      'Name: ${pharmacyList[i].name}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone: ${pharmacyList[i].phone}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            makeCall('tel:${pharmacyList[i].phone}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    currentPosition == null
                        ? Text(
                            'Distance: ${((Geolocator.distanceBetween(customer.lat.toDouble(), customer.lng.toDouble(), pharmacyList[i].lat.toDouble(), pharmacyList[i].lng.toDouble())) / 1000.0).toStringAsFixed(2)}KM',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )
                        : Text(
                            'Distance: ${((Geolocator.distanceBetween(currentPosition!.latitude, currentPosition!.longitude, pharmacyList[i].lat.toDouble(), pharmacyList[i].lng.toDouble())) / 1000.0).toStringAsFixed(2)}KM',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email: ${pharmacyList[i].email}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        GestureDetector(
                          onTap: () {
                            makeCall('mailto:${pharmacyList[i].email}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              LatLng(pharmacyList[i].lat.toDouble(),
                  pharmacyList[i].lng.toDouble()),
            );
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    addMarker(pharmacyProvider.pharmacyList, customerProvider.currentCustomer);
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffE7E7E8),
      bottomNavigationBar: const MyBottomBar(
        currentIndex: 1,
      ),
      body: Container(
          child: Stack(
        children: [
          Container(
            // padding: EdgeInsets.only(bottom: 50),
            child: GoogleMap(
              markers: markers.toSet(),
              initialCameraPosition: initialCameraPosition,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                  customInfoWindowController.googleMapController = controller;
                });
              },
              onTap: (cordinate) {
                _controller.animateCamera(CameraUpdate.newLatLng(cordinate));

                customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (cordinate) {
                customInfoWindowController.onCameraMove!();
              },
            ),
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 200,
            width: 250,
          ),
        ],
      )),
    ));
  }

  Future<void> makeCall(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch';
    }
  }
}
