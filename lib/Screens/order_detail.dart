import 'package:flutter/material.dart';
import 'package:medi_tech/Models/Product.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Screens/Return/Exchange/return_exchange_screen.dart';
import 'package:provider/provider.dart';

import '../Models/Order.dart';
import '../Models/Pharmacy.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({required this.order, Key? key}) : super(key: key);
  Order order;
  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    String orderStatus = "";
    orderStatus = order.isCompleted ? "Completed" : "inProcess";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order No.  ${order.orderId}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              children: [
                Text(
                  'Total Products:  ${order.cartList.length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  orderStatus,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: orderStatus == "Completed"
                          ? Colors.green
                          : Colors.blue),
                ),
              ],
            ),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.64,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: order.cartList.length,
                  itemBuilder: (context, index) {
                    Product tempProduct = pharmacyProvider
                        .getProductFromId(order.cartList[index].productId);
                    Pharmacy tempPharmacy = pharmacyProvider
                        .getPharmacyFromId(order.cartList[index].pharmacyId);
                    return Card(
                        child: ListTile(
                      leading: Image.network(
                        tempProduct.imagePath,
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From:  ${tempPharmacy.name}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                'Product:  ${tempProduct.name}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(
                              'Items: ${order.cartList[index].count}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Price: ${tempProduct.sellPrice * order.cartList[index].count}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ]),
                      trailing: (orderStatus == "Completed")
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReturnExchangeScreen(
                                              returnProduct:
                                                  order.cartList[index],
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: (BorderRadius.circular(4)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        spreadRadius: 0.05,
                                      ),
                                    ],
                                    color: Colors.blueAccent),
                                child: const Text(
                                  'Return &\nExchange',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                    ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
