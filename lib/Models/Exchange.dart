class Exchange {
  String id = "";
  String productId;
  String pharmacyId;
  String customerId;
  int count;
  String reason;
  String receipt;
  String status;

  Exchange(
      {required this.id,
      required this.productId,
      required this.pharmacyId,
      required this.customerId,
      required this.count,
      required this.reason,
      required this.status,
      required this.receipt});
  Exchange.fromSnapshot(snapshot)
      : id = snapshot.id,
        productId = snapshot.data()['productId'],
        pharmacyId = snapshot.data()['pharmacyId'],
        customerId = snapshot.data()['customerId'],
        count = snapshot.data()['count'],
        reason = snapshot.data()['reason'],
        status = snapshot.data()['status'],
        receipt = snapshot.data()['receipt'];
}
