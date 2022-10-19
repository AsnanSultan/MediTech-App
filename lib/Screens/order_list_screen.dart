import 'package:flutter/material.dart';
import 'package:medi_tech/Provider/OrderProvider.dart';
import 'package:medi_tech/Screens/order_detail.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: orderProvider.orderList.length,
          itemBuilder: (context, index) {
            String orderStatus = "";
            orderStatus = orderProvider.orderList[index].isCompleted
                ? "Completed"
                : "inProcess";
            return Card(
              elevation: 5,
              margin: const EdgeInsets.all(8),
              shadowColor: Colors.blueAccent,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                                order: orderProvider.orderList[index],
                              )));
                },
                child: ListTile(
                  leading: Image.asset('assets/images/orderMedicine.png'),
                  title: Text(
                    orderProvider.orderList[index].orderId,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.blue,
                        fontSize: 16),
                  ),
                  subtitle: Text(
                      orderProvider.orderList[index].dateTime.substring(0, 19)),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        orderStatus,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: orderStatus == "Completed"
                                ? Colors.green
                                : Colors.blue),
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
          }),
    );
  }
}
