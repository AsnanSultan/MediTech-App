import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_tech/Models/Exchange.dart';
import 'package:medi_tech/Models/Pharmacy.dart';
import 'package:medi_tech/Models/Product.dart';
import 'package:medi_tech/Provider/customer_provider.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Widgets/my_text_button.dart';
import 'package:provider/provider.dart';

import '../../../Models/Cart.dart';
import '../../../Models/openMap.dart';
import '../../../constants.dart';
import 'PickTheRecipt.dart';

class ReturnExchangeScreen extends StatefulWidget {
  ReturnExchangeScreen({required this.returnProduct, isView, Key? key})
      : super(key: key);

  Cart returnProduct;
  bool isView = false;
  @override
  State<ReturnExchangeScreen> createState() => _ReturnExchangeScreenState();
}

class _ReturnExchangeScreenState extends State<ReturnExchangeScreen> {
  TextEditingController details = TextEditingController();
  String customerId = "";
  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    customerId = customerProvider.currentCustomer.id;
    Product tempProduct =
        pharmacyProvider.getProductFromId(widget.returnProduct.productId);
    Pharmacy tempPharmacy =
        pharmacyProvider.getPharmacyFromId(widget.returnProduct.pharmacyId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Return/Exchange"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Info",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Card(
                child: Row(
                  children: [
                    Image.network(
                      tempProduct.imagePath,
                      width: 90,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product Name: ${tempProduct.name}'),
                        Text('Total Items: ${widget.returnProduct.count}'),
                        Text('Product Price: ${tempProduct.sellPrice}'),
                        Text('Category: ${tempProduct.category}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Pharmacy Info",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Card(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                      child: Image.asset(
                        'assets/images/pharmacy.png',
                        width: 80,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${tempPharmacy.name}'),
                        Text('Number: ${tempPharmacy.phone}'),
                        Text('Email : ${tempPharmacy.email}'),
                        Row(
                          children: [
                            Text("Location: "),
                            GestureDetector(
                              onTap: () {
                                MapUtils.openMap(tempPharmacy.lat.toDouble(),
                                    tempPharmacy.lng.toDouble());
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.blueAccent,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Direction",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: details,
                  onChanged: (val) {
                    // purchasePrice = double.parse(val);
                  },
                  style: kBodyText.copyWith(color: Colors.blue),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  //textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Reason",
                    contentPadding: const EdgeInsets.all(20),
                    hintText:
                        "Why you want to Return or Exchange this product?",
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
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${tempProduct.sellPrice * widget.returnProduct.count}Pkr',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (!widget.isView)
                MyTextButton(
                    buttonName: 'Confirm the Product',
                    onTap: () {
                      Exchange tempExchange = Exchange(
                          id: "",
                          productId: tempProduct.id,
                          pharmacyId: tempPharmacy.id,
                          customerId: customerId,
                          count: widget.returnProduct.count,
                          reason: details.text,
                          status: 'inProcess',
                          receipt: '');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PicTheRecipt(
                                    exchangeProduct: tempExchange,
                                  )));
                    },
                    bgColor: Colors.blueAccent,
                    textColor: Colors.white,
                    isLoading: false),
            ],
          ),
        ),
      ),
    );
  }
}
