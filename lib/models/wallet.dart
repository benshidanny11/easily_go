import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/models/transaction.dart';

class Wallet {
  String id;
  double balance;
  List<dynamic> transactions;
  String driverId;

  Wallet(
      {required this.id,
      required this.balance,
      required this.driverId,
      required this.transactions});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "balance": balance,
      "driverId": driverId,
      "transactions": transactions.map((e) => e.toJson()).toList()
    };
  }

  factory Wallet.fromJson(json) {
    print(json['transactions']);
    return Wallet(
        id: json["id"],
        balance: json["balance"],
        transactions:
            json['transactions'].map((e) { return TransactionModel.fromJson(e);}).toList(),
        driverId: json["driverId"]);
  }
}
