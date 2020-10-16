import 'dart:async';

import 'models/models.dart';

abstract class TransactionRepository {
  Future<void> addNewTransaction(Transaction transaction);

  Future<void> deleteTransaction(Transaction transaction);

  Stream<List<Transaction>> transactions(String uid);

  Future<void> updateTransaction(Transaction transaction);
}