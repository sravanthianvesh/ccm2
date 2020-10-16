import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:transactions_repository/transactions_repository.dart';
import 'entities/entities.dart';

class FirebaseTransactionRepository implements TransactionRepository {
  final transactionCollection =
  firestore.FirebaseFirestore.instance.collection('transactions');

  @override
  Future<void> addNewTransaction(Transaction transaction) {
    return transactionCollection.add(transaction.toEntity().toDocument());
  }

  @override
  Future<void> deleteTransaction(Transaction transaction) async {
    return transactionCollection.doc(transaction.id).delete();
  }

  @override
  Stream<List<Transaction>> transactions(String uid) {
    return transactionCollection.where('user_id', isEqualTo: uid).
    snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromEntity(
          TransactionEntity.fromSnapshot(doc)
      )).toList();
    });
  }

  @override
  Future<void> updateTransaction(Transaction update) {
    return transactionCollection
        .doc(update.id)
        .update(update.toEntity().toDocument());
  }
}
