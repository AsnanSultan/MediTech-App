import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi_tech/Models/CustomOrder.dart';
import 'package:medi_tech/Provider/CustomOrderProvider.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:medi_tech/Screens/home.dart';
import 'package:provider/provider.dart';

import '../../Widgets/my_text_button.dart';
import '../../constants.dart';

class CustomOrderRequest extends StatefulWidget {
  const CustomOrderRequest({Key? key}) : super(key: key);

  @override
  State<CustomOrderRequest> createState() => _CustomOrderRequestState();
}

class _CustomOrderRequestState extends State<CustomOrderRequest> {
  File? selectedPhoto;
  bool isCameraClick = false;
  TextEditingController instructions = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CustomOrderProvider customOrderProvider =
        Provider.of<CustomOrderProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Order Request"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Container(
            height: MediaQuery.of(context).size.height - 130,
            child: Column(
              children: [
                selectedPhoto == null
                    ? Column(
                        children: [
                          Text(
                            "If you have  Doctor Prescription Then Click on this Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 32),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!isCameraClick) {
                                isCameraClick = true;
                                await openCamera();
                                setState(() {});
                                var timer = Timer.periodic(Duration(seconds: 2),
                                    (timer) {
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
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: 220,
                        width: 180,
                        child: Image.file(
                          selectedPhoto!,
                          fit: BoxFit.fill,
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: instructions,
                    onChanged: (val) {
                      // purchasePrice = double.parse(val);
                    },
                    style: kBodyText.copyWith(color: Colors.blue),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    //textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Instructions",
                      contentPadding: const EdgeInsets.all(20),
                      hintText: "Please Describe your product",
                      hintStyle: TextStyle(fontSize: 12),
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
                Spacer(),
                MyTextButton(
                    buttonName: "Next",
                    onTap: () async {
                      if (selectedPhoto != null ||
                          instructions.text.isNotEmpty) {
                        CustomOrder tempCustomOrder = CustomOrder(
                            id: "",
                            pharmacyId: "null",
                            customerId: customerProvider.currentCustomer.id,
                            prescription: "null",
                            instruction: instructions.text,
                            status: "Requested");
                        await customOrderProvider
                            .requestCustomOrder(tempCustomOrder, selectedPhoto!)
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        });
                      }
                    },
                    bgColor: Colors.blueAccent,
                    textColor: Colors.white,
                    isLoading: customOrderProvider.isLoading)
              ],
            ),
          ),
        ),
      ),
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
