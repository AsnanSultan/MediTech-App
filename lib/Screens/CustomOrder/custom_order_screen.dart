import 'package:flutter/material.dart';
import 'package:medi_tech/Models/CustomOrder.dart';
import 'package:medi_tech/Provider/CustomOrderProvider.dart';
import 'package:medi_tech/Screens/CustomOrder/custom_order_request.dart';
import 'package:provider/provider.dart';

class CustomOrderScreen extends StatelessWidget {
  const CustomOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomOrderProvider customOrderProvider =
        Provider.of<CustomOrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Orders"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomOrderRequest()));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: customOrderProvider.getCustomOrdersList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: customOrderProvider.customOrderList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(8),
                      shadowColor: Colors.blueAccent,
                      child: GestureDetector(
                        onTap: () {
                          /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                order: orderProvider.orderList[index],
                              )));*/
                        },
                        child: ListTile(
                          leading: Image.network(
                            '${customOrderProvider.customOrderList[index].prescription}',
                            height: 55,
                          ),
                          subtitle: Text(
                              '${customOrderProvider.customOrderList[index].instruction}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${customOrderProvider.customOrderList[index].status}',
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
