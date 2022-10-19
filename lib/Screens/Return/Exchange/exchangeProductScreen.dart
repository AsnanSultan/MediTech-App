import 'package:flutter/material.dart';
import 'package:medi_tech/Models/Exchange.dart';
import 'package:medi_tech/Provider/exchangeProvider.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:provider/provider.dart';

import '../../../Models/Product.dart';
import 'exchange_product_detail.dart';

class ExchangeProductsScreen extends StatefulWidget {
  const ExchangeProductsScreen({Key? key}) : super(key: key);

  @override
  State<ExchangeProductsScreen> createState() => _ExchangeProductsScreenState();
}

class _ExchangeProductsScreenState extends State<ExchangeProductsScreen> {
  @override
  Widget build(BuildContext context) {
    ExchangeProvider exchangeProvider = Provider.of<ExchangeProvider>(context);
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Return/Exchange Products"),
      ),
      body: /* exchangeProvider.exchangeList.isEmpty
          ? Center(
              child: Image.asset('assets/images/dataNotFound.png'),
            )
          :*/
          FutureBuilder(
              future: exchangeProvider.getReturnExchangeList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: exchangeProvider.exchangeList.length,
                      itemBuilder: (context, index) {
                        Product tempProduct = pharmacyProvider.getProductFromId(
                            exchangeProvider.exchangeList[index].productId);
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(8),
                          shadowColor: Colors.blueAccent,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ExchangeProductDetailScreen(
                                            exchangeProduct: exchangeProvider
                                                .exchangeList[index],
                                          )));
                            },
                            child: ListTile(
                              leading: Image.network(
                                '${tempProduct.imagePath}',
                                height: 55,
                              ),
                              title: Text(
                                exchangeProvider.exchangeList[index].id,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.blue,
                                    fontSize: 16),
                              ),
                              subtitle: Text('${tempProduct.name}'),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${exchangeProvider.exchangeList[index].status}',
                                  ),
                                  /*if (orderStatus == "Completed")
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReturnExchangeScreen()));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: (BorderRadius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        spreadRadius: 0.05,
                                      ),
                                    ],
                                    color: Colors.blueAccent),
                                child: Text(
                                  'Return/Exchange',
                                  style:
                                      TextStyle(fontSize: 8, color: Colors.black),
                                ),
                              ),
                            ),*/
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }
}
