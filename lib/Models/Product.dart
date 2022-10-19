class Product {
  String id;
  String name;
  String category;
  num sellPrice;
  num purchasePrice;
  String description;
  int totalItems;
  String expireDate;
  String imagePath;
  String pharmacyId;
  bool isHeart = false;

  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.sellPrice,
      required this.purchasePrice,
      required this.description,
      required this.totalItems,
      required this.expireDate,
      required this.imagePath,
      required this.pharmacyId});

  Product.fromSnapshot(snapshot)
      : id = snapshot.id,
        name = snapshot.data()["Name"],
        category = snapshot.data()["category"],
        sellPrice = snapshot.data()["sellPrice"],
        purchasePrice = snapshot.data()["purchasePrice"],
        description = snapshot.data()["description"],
        totalItems = snapshot.data()["totalItems"],
        expireDate = snapshot.data()["expireDate"],
        imagePath = snapshot.data()["imageUrl"],
        pharmacyId = snapshot.data()["pharmacyId"];
}
