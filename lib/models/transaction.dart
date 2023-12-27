

class TransactionModel {
  String transactionId;
  String walletId;
  String userId;
  double transactionAmount;
  String accountNumber;
  String paymentType;
  String paymentReference;
  String transactionStatus;
  DateTime transactionDate;
  String comment;

  TransactionModel(
      {required this.transactionId,
      required this.transactionAmount,
      required this.transactionStatus,
      required this.paymentReference,
      required this.paymentType,
      required this.transactionDate,
      required this.comment,
      required this.walletId,
      required this.userId,
      required this.accountNumber,
      });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'transactionAmount': transactionAmount,
      'walletId': walletId,
      'userId':userId,
      'transactionStatus': transactionStatus,
      'paymentReference': paymentReference,
      'paymentType': paymentType,
      'transactionDate': transactionDate,
      'comment':comment,
      'accountNumber':accountNumber,
    };
  }

  factory TransactionModel.fromJson(dynamic json) {
    return TransactionModel(
        transactionId: json['transactionId'],
        transactionAmount: json['transactionAmount'],
        walletId: json['walletId'],
        userId: json['userId'],
        transactionStatus: json['transactionStatus'],
        paymentReference: json['paymentReference'],
        paymentType: json['paymentType'],
        transactionDate: json['transactionDate'].toDate(),
        comment: json['comment'],
        accountNumber: json['accountNumber'],);
  }

}
