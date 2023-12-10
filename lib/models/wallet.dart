import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  String id;
  String docId;
  double balance;
  List<Transaction> transactions;

  Wallet(
      {required this.id,
      required this.balance,
      required this.docId,
      required this.transactions});
}
