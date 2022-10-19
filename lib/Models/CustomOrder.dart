class CustomOrder {
  String id = "";
  String pharmacyId = "";
  String customerId = "";
  String prescription = "";
  String instruction = "";
  String status = "";
  CustomOrder({
    required this.id,
    required this.pharmacyId,
    required this.customerId,
    required this.prescription,
    required this.instruction,
    required this.status,
  });
  CustomOrder.fromSnapshot(snapshot)
      : id = snapshot.id,
        pharmacyId = snapshot.data()['pharmacyId'],
        customerId = snapshot.data()['customerId'],
        prescription = snapshot.data()['prescription'],
        instruction = snapshot.data()['instruction'],
        status = snapshot.data()['status'];
}
