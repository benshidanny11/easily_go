import 'package:easylygo_app/models/wallet.dart';

class TransactionModel {
  String transactionId;
  String walletId;
  String userId;
  double transactionAmount;
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
      required this.userId
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
        transactionDate: json['transactionDate'],
        comment: json['comment']);
  }

}
