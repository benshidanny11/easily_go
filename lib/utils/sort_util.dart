import 'package:easylygo_app/models/transaction.dart';

class SortUtil {
  static void sortTransactions(List<TransactionModel> transations) {
    transations.sort((a, b) {
      var date1 = a.transactionDate;
      var date2 = b.transactionDate;
      return date2.compareTo(date1);
    });
  }
}
