class Customer {
  String id = "";
  String name;
  String email;
  String phone;
  num lat;
  num lng;
  Customer(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.lat,
      required this.lng});
  Customer.fromSnapshot(snapshot)
      : id = snapshot.id,
        name = snapshot.data()['name'],
        email = snapshot.data()['email'],
        phone = snapshot.data()['number'],
        lat = snapshot.data()['lat'],
        lng = snapshot.data()['lng'];
}
