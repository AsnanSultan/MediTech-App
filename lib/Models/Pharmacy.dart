import 'Product.dart';

class Pharmacy {
  String id = "";
  String name;
  String email;
  String phone;
  num lat;
  num lng;
  List<Product> products = [];
  Pharmacy(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.lat,
      required this.lng});
  Pharmacy.fromSnapshot(snapshot)
      : id = snapshot.id,
        name = snapshot.data()['name'],
        email = snapshot.data()['email'],
        phone = snapshot.data()['number'],
        lat = snapshot.data()['lat'],
        lng = snapshot.data()['lng'];
}
