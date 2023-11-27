class Transactions {
  final int TransID;
  final String TransDesc;
  final String TransStatus;
  final String TransDateTime;

  Transactions(
      {required this.TransID,
      required this.TransDesc,
      required this.TransStatus,
      required this.TransDateTime});

  Map<String, dynamic> toMap() {
    return {
      'TransID': TransID,
      'TransDesc': TransDesc,
      'TransStatus': TransStatus,
      'TransDateTime': TransDateTime
    };
  }

  // Create a Product object from a Map
  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      TransID: map['TransID'],
      TransDesc: map['TransDesc'],
      TransStatus: map['TransStatus'],
      TransDateTime: map['TransDateTime'],
    );
  }
}
