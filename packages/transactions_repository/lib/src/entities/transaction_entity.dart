import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  const TransactionEntity(this.id,
      this.date,
      this.category,
      this.description,
      this.quantity,
      this.totalAmount,
      this.amountPaid,
      this.incompletePayment,
      this.supplier,
      this.userId);

  final String id;
  final String date;
  final String category;
  final String description;
  final String quantity;
  final double totalAmount;
  final double amountPaid;
  final bool incompletePayment;
  final String supplier;
  final String userId;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'date': date,
      'category': category,
      'description': description,
      'quantity': quantity,
      'total_amount': totalAmount,
      'amount_paid': amountPaid,
      'incomplete_payment': incompletePayment,
      'supplier': supplier,
      'user_id': userId,
    };
  }

  @override
  List<Object> get props => [id,
    date,
    category,
    description,
    quantity,
    totalAmount,
    amountPaid,
    incompletePayment,
    supplier,
    userId,
  ];

  @override
  String toString() {
    return 'TransactionEntity { id: $id,'
        'date: $date,'
        'category: $category,'
        'description: $description,'
        'quantity: $quantity,'
        'total_amount: $totalAmount,'
        'amount_paid: $amountPaid,'
        'incomplete_payment: $incompletePayment,'
        'supplier: $supplier,'
        'user_id: $userId }';
  }

  static TransactionEntity fromJson(Map<String, Object> json) {
    return TransactionEntity(
      json['id'] as String,
      json['date'] as String,
      json['category'] as String,
      json['description'] as String,
      json['quantity'] as String,
      json['total_amount'] as double,
      json['amount_paid'] as double,
      json['incomplete_payment'] as bool,
      json['supplier'] as String,
      json['user_id'] as String,
    );
  }

  static TransactionEntity fromSnapshot(DocumentSnapshot snap) {
    var transact = snap.data();
    return TransactionEntity(
      snap.id,
      transact['date'].toString(),
      transact['category'].toString(),
      transact['description'].toString(),
      transact['quantity'].toString(),
      double.parse(transact['total_amount'].toString()?? '0.00'),
      double.parse(transact['amount_paid'].toString()?? '0.00'),
      transact['incomplete_payment'].toString().toLowerCase() == 'true',
      transact['supplier'].toString(),
      transact['user_id'].toString(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'date': date,
      'category': category,
      'description': description,
      'quantity': quantity,
      'total_amount': totalAmount,
      'amount_paid': amountPaid,
      'incomplete_payment': incompletePayment,
      'supplier': supplier,
      'user_id': userId
    };
  }
}
