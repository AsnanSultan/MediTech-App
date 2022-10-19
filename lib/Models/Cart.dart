class Cart {
  String id = "";
  String userId = "";
  String productId = "";
  String pharmacyId = "";
  int count = 0;
  //double discount=0;

  Cart.add(this.id, this.userId, this.pharmacyId, this.productId, this.count);

  Cart(
      {required this.id,
      required this.userId,
      required this.pharmacyId,
      required this.productId,
      required this.count});
  Cart.fromSnapshot(snapshot)
      : id = snapshot.id,
        userId = snapshot.data()['userId'],
        pharmacyId = snapshot.data()['pharmacyId'],
        productId = snapshot.data()['productId'],
        count = snapshot.data()['count'];
  Cart.fromSnapshot2(snapshot)
      : id = snapshot.data("id"),
        userId = snapshot.data()['userId'],
        pharmacyId = snapshot.data()['pharmacyId'],
        productId = snapshot.data()['productId'],
        count = snapshot.data()['count'];

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map["id"],
      userId: map["userId"],
      pharmacyId: map["pharmacyId"],
      productId: map["productId"],
      count: map["count"],
    );
  }
  toMap() => {
        "id": id,
        "userId": userId,
        "pharmacyId": pharmacyId,
        "productId": productId,
        "count": count,
      };
}
