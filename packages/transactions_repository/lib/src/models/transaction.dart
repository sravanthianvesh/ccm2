import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Transaction {
  Transaction(this.date,
      this.category,
      String description,
      this.quantity,
      this.totalAmount,
      this.amountPaid,
      this.incompletePayment,
      String supplier,
      this.userId,
      {String id}
      )
      : description = description ?? '',
        supplier = supplier ?? '',
        id = id;

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

  Transaction copyWith({String id,
    String date,
    String category,
    String description,
    String quantity,
    double totalAmount,
    double amountPaid,
    bool incompletePayment,
    String supplier,
    String userId,
  }) {
    return Transaction(date ?? this.date,
        category ?? this.category,
        description ?? this.description,
        quantity ?? this.quantity,
        totalAmount ?? this.totalAmount,
        amountPaid ?? this.amountPaid,
        incompletePayment ?? this.incompletePayment,
        supplier ?? this.supplier,
        userId ?? this.userId,
        id: id ?? this.id,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      category.hashCode ^
      description.hashCode ^
      quantity.hashCode ^
      totalAmount.hashCode ^
      amountPaid.hashCode ^
      incompletePayment.hashCode ^
      supplier.hashCode ^
      userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Transaction &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              date == other.date &&
              category == other.category &&
              description == other.description &&
              quantity == other.quantity &&
              totalAmount == other.totalAmount &&
              amountPaid == other.amountPaid &&
              incompletePayment == other.incompletePayment &&
              supplier == other.supplier &&
              userId == other.userId;

  @override
  String toString() {
    return 'Transaction { id: $id,'
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

  TransactionEntity toEntity() {
    return TransactionEntity(id,
        date,
        category,
        description,
        quantity,
        totalAmount,
        amountPaid,
        incompletePayment,
        supplier,
        userId,
    );
  }

  static Transaction fromEntity(TransactionEntity entity) {
    return Transaction(
      entity.date,
      entity.category,
      entity.description,
      entity.quantity,
      entity.totalAmount,
      entity.amountPaid,
      entity.incompletePayment,
      entity.supplier,
      entity.userId,
      id: entity.id,
    );
  }
}
