import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/config/config.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/transaction.dart';
import 'package:easylygo_app/models/wallet.dart';
import 'package:easylygo_app/utils/firestore_util.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class WalletService {
  static Stream<Wallet> getDriverWalletInfo(String driverId) {
    StreamController<Wallet> controller = StreamController<Wallet>();

    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("wallets")
          .where("driverId", isEqualTo: driverId)
          .snapshots()
          .listen((querySnapshot) {
        QueryDocumentSnapshot walletDocument = querySnapshot.docs[0];
        Wallet wallet = Wallet.fromJson(walletDocument);
        controller.add(wallet);
      }, onError: (error) {
        controller.addError(error);
      });
    });
    return controller.stream;
  }

  static Future<Wallet> getFutureDriverWalletInfo(String driverId) async {
    await FirebaseUtil.initializeFirebase();
    QuerySnapshot walletSnapshoot =
        await FirebaseUtil.collectionReferene("wallets")
            .where("driverId", isEqualTo: driverId)
            .get();
    QueryDocumentSnapshot walletDocument = walletSnapshoot.docs[0];
    Wallet wallet = Wallet.fromJson(walletDocument);
    return wallet;
  }

  static Future<bool> applyServiceCostOnWallet(
      String driverId, double amount) async {
    await FirebaseUtil.initializeFirebase();
    QuerySnapshot walletSnapshoot =
        await FirebaseUtil.collectionReferene("wallets")
            .where("driverId", isEqualTo: driverId)
            .get();
    QueryDocumentSnapshot walletDocument = walletSnapshoot.docs[0];
    Wallet wallet = Wallet.fromJson(walletDocument);
    wallet.balance = wallet.balance - amount;
    if (walletSnapshoot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('wallets')
          .doc(walletSnapshoot.docs[0].id)
          .update(wallet.toJson());
      return true;
    }
    return false;
  }

  static Future<bool> topUpWallet(String driverId, String walletId,
      String phoneNumber, double amount) async {
    try {
      const paymentUrl =
          '$PAYMENT_API_LINK_RWANDA/transactions/cashin?Idempotency-Key=OldbBsHAwAdcYalKLXuiMcqRrdEcDGRv';
      var uuid = const Uuid().v4();
      TransactionModel transactionModel = TransactionModel(
          transactionId: uuid,
          transactionAmount: amount,
          transactionStatus: TRANSACTION_INITIATED,
          paymentReference: '',
          paymentType: 'TOPUP',
          transactionDate: DateTime.now(),
          comment: 'TRansaction initiated',
          userId: driverId,
          walletId: walletId,
          accountNumber: phoneNumber);
      final addedTransaction =
          await FirebaseUtil.collectionReferene("transactions")
              .add(transactionModel.toJson());

      String? accessToken = await getAccessToken();
      if (accessToken != null && accessToken != '') {
        final paymentResponse = await http.post(
            Uri.parse(
              paymentUrl,
            ),
            headers: {'Authorization': 'Bearer $accessToken'},
            body:
                convert.jsonEncode({"amount": amount, "number": phoneNumber}));

        final paymentData = convert.jsonDecode(paymentResponse.body);
        print(paymentData['']);
        transactionModel.paymentReference = paymentData['ref'];
        transactionModel.transactionStatus = TRANSACTION_PENDING;
        addedTransaction.update(transactionModel.toJson());
        // Updatate transaction;
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print("Errorrrr in excepiton $err");
      return false;
    }
  }

  static Stream<List<TransactionModel>> getDriverTransactions(String driverId) {
    StreamController<List<TransactionModel>> controller =
        StreamController<List<TransactionModel>>();
    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("transactions")
          .where("userId", isEqualTo: driverId)
          .snapshots()
          .listen((querySnapshot) {
        List<TransactionModel> transactions = querySnapshot.docs
            .map((doc) => TransactionModel.fromJson(doc.data()))
            .toList();
        controller.add(transactions);
      }, onError: (error) {
        controller.addError(error);
      });
    });

    return controller.stream;
  }

  static Future<bool> updateWallet(TransactionModel transactionModel) async {
    final paymentEventUrl =
        '$PAYMENT_API_LINK_RWANDA/events/transactions?ref=${transactionModel.paymentReference}';
    String? accessToken = await getAccessToken();
    if (accessToken != null && accessToken != '') {
      final paymentEventResponse = await http.get(
          Uri.parse(
            paymentEventUrl,
          ),
          headers: {'Authorization': 'Bearer $accessToken'});
      dynamic paymentEventData = convert.jsonDecode(paymentEventResponse.body);
      if (paymentEventData != null &&
          paymentEventData['transactions'][0]['data']['status'] != null) {
        if (paymentEventData['transactions'][0]['data']['status'] == 'failed') {
          QuerySnapshot snapshotTransaction =
              await FirebaseUtil.collectionReferene('transactions')
                  .where('transactionId',
                      isEqualTo: transactionModel.transactionId)
                  .get();
          transactionModel.transactionStatus = TRANSACTION_FAILED;
          if (snapshotTransaction.docs.isNotEmpty) {
            await FirebaseUtil.collectionReferene('transactions')
                .doc(snapshotTransaction.docs[0].id)
                .update(transactionModel.toJson());
          }
          return true;
        } else if (paymentEventData['transactions'][0]['data']['status'] ==
            'successful') {
          QuerySnapshot snapshotTransaction =
              await FirebaseUtil.collectionReferene('transactions')
                  .where('transactionId',
                      isEqualTo: transactionModel.transactionId)
                  .get();
          QuerySnapshot snapshotWallet =
              await FirebaseUtil.collectionReferene('wallets')
                  .where('id', isEqualTo: transactionModel.walletId)
                  .get();

          Wallet wallet = Wallet.fromJson(snapshotWallet.docs[0].data());
          wallet.balance = wallet.balance + transactionModel.transactionAmount;

          if (snapshotWallet.docs.isNotEmpty) {
            await FirebaseUtil.collectionReferene('wallets')
                .doc(snapshotWallet.docs[0].id)
                .update(wallet.toJson());
          }
          if (snapshotTransaction.docs.isNotEmpty) {
            transactionModel.transactionStatus = TRANSACTION_SUCEEDED;
            await FirebaseUtil.collectionReferene('transactions')
                .doc(snapshotTransaction.docs[0].id)
                .update(transactionModel.toJson());
          }
          return true;
        }
      } else {
        return false;
      }
    }

    return false;
  }

  static Future<String?> getAccessToken() async {
    const authUrl = '$PAYMENT_API_LINK_RWANDA/auth/agents/authorize';
    final authResponse = await http.post(
        Uri.parse(
          authUrl,
        ),
        body: convert.jsonEncode({
          "client_id": PAYMENT_API_ID_RWANDA,
          "client_secret": PAYMENT_API_SECRET_RWANDA
        }));
    dynamic authData = convert.jsonDecode(authResponse.body);
    String accessToken = authData['access'];

    return accessToken;
  }
}
