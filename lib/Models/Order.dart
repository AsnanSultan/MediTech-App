import 'Cart.dart';

class Order {
  String orderId;
  String userId;
  num lat;
  num lng;
  String contactInfo;
  String dateTime;
  bool isPayNow;
  bool isCompleted;
  List<Cart> cartList = [];
  Order({
    required this.orderId,
    required this.userId,
    required this.lat,
    required this.lng,
    required this.contactInfo,
    required this.dateTime,
    required this.isPayNow,
    required this.isCompleted,
    required this.cartList,
  });

  Order.fromSnapshot(snapshot)
      : orderId = snapshot.id,
        userId = snapshot.data()['userId'],
        lat = snapshot.data()['lat'],
        lng = snapshot.data()['lng'],
        contactInfo = snapshot.data()['contactInfo'],
        dateTime = snapshot.data()['dateTime'],
        isPayNow = (snapshot.data()['isPayNow']),
        isCompleted = snapshot.data()['isCompleted'];
}
