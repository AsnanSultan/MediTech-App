import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView.builder(
          physics:
              const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: 3,
          itemBuilder: (context, index) {
            return const Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              shadowColor: Colors.blueAccent,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.notifications,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Order Placed Successfully",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Date: 12-08-2022"),
              ),
            );
          }),
    );
  }
}
