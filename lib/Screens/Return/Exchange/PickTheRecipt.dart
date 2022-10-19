import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi_tech/Models/Exchange.dart';
import 'package:medi_tech/Provider/exchangeProvider.dart';
import 'package:medi_tech/Screens/home.dart';
import 'package:medi_tech/Widgets/my_text_button.dart';
import 'package:provider/provider.dart';

import '../../../Models/Cart.dart';

class PicTheRecipt extends StatefulWidget {
  PicTheRecipt({required this.exchangeProduct, Key? key}) : super(key: key);
  Exchange exchangeProduct;
  @override
  State<PicTheRecipt> createState() => _PicTheReciptState();
}

class _PicTheReciptState extends State<PicTheRecipt> {
  //final picker = ImagePicker();
  File? selectedPhoto;
  bool isCameraClick = false;
  @override
  Widget build(BuildContext context) {
    ExchangeProvider exchangeProvider = Provider.of<ExchangeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick the picture of recipet"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        child: selectedPhoto == null
            ? imageNotSelected()
            : imageSelected(exchangeProvider, widget.exchangeProduct),
      ),
    );
  }

  Widget imageSelected(
      ExchangeProvider exchangeProvider, Exchange exchangeProduct) {
    return Column(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: Colors.green,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 370,
          width: 250,
          child: Image.file(
            selectedPhoto!,
            fit: BoxFit.fill,
          ),
        ),
        Spacer(),
        MyTextButton(
            buttonName: "Next",
            onTap: () {
              exchangeProvider
                  .requestReturnExchange(exchangeProduct, selectedPhoto!)
                  .then((value) {
                Fluttertoast.showToast(
                    msg: "Return/Exchange Request Submit", // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                    backgroundColor: Colors.blueAccent, // location
                    timeInSecForIosWeb: 1 // duration
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });
            },
            bgColor: Colors.blueAccent,
            textColor: Colors.white,
            isLoading: exchangeProvider.isLoading)
      ],
    );
  }

  Widget imageNotSelected() {
    return Column(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: Colors.green,
        ),
        SizedBox(
          height: 20,
        ),
        Text(' HOLD ON!', style: TextStyle(color: Colors.green, fontSize: 24)),
        SizedBox(
          height: 20,
        ),
        Text(
          "Please pick the Picture of Your Product Receipt by Clicking on this Camera Icon:",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 70,
        ),
        GestureDetector(
          onTap: () async {
            if (!isCameraClick) {
              isCameraClick = true;
              await openCamera();
              setState(() {});
              var timer = Timer.periodic(Duration(seconds: 2), (timer) {
                isCameraClick = false;
              });

              timer.cancel();
            }
          },
          child: Icon(
            Icons.camera_alt,
            size: 70,
          ),
        ),
        Spacer(),
        MyTextButton(
            buttonName: "Next",
            onTap: () {
              Fluttertoast.showToast(
                  msg: "Please click the snap of product receipt", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                  backgroundColor: Colors.blueAccent, //  // location
                  timeInSecForIosWeb: 1 // duration
                  );
            },
            bgColor: Colors.blueAccent,
            textColor: Colors.white,
            isLoading: false)
      ],
    );
  }

  Future<void> openCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        selectedPhoto = File(pickedFile.path);
        // widget.photoCallBack(selectedPhoto!);
      } else {
        print('No image selected.');
      }
    });
  }
}
