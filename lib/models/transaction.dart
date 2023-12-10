class TransactionModel {
  String transactionId;
  String transactionDocId;
  double transactionAmount;
  String paymentType;
  String paymentReference;
  String transactionStatus;
  DateTime transactionDate;

  TransactionModel(
      {required this.transactionId,
      required this.transactionAmount,
      required this.transactionDocId,
      required this.transactionStatus,
      required this.paymentReference,
      required this.paymentType,
      required this.transactionDate});

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'transactionAmount': transactionAmount,
      'transactionDocId': transactionDocId,
      'transactionStatus': transactionStatus,
      'paymentReference': paymentReference,
      'paymentType': paymentType,
      'transactionDate': transactionDate
    };
  }

  factory TransactionModel.fromJson(dynamic json) {
    return TransactionModel(
        transactionId: json['transactionId'],
        transactionAmount: json['transactionAmount'],
        transactionDocId: json['transactionDocId'],
        transactionStatus: json['transactionStatus'],
        paymentReference: json['paymentReference'],
        paymentType: json['paymentType'],
        transactionDate: json['transactionDate']);
  }

}
