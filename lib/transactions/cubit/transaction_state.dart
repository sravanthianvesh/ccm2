part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  const TransactionState({
    this.date = const Date.pure(),
    this.category = const Category.pure(),
    this.description = const Description.pure(),
    this.quantity = const Quantity.pure(),
    this.totalAmount = const TotalAmount.pure(),
    this.amountPaid = const AmountPaid.pure(),
    this.supplier = const Supplier.pure(),
    this.status = FormzStatus.pure,
  });

  final Date date;
  final Category category;
  final Description description;
  final Quantity quantity;
  final TotalAmount totalAmount;
  final AmountPaid amountPaid;
  final Supplier supplier;
  final FormzStatus status;

  @override
  List<Object> get props => [date, category, description, quantity, totalAmount, amountPaid, supplier, status];

  TransactionState copyWith({
    Date date,
    Category category,
    Description description,
    Quantity quantity,
    TotalAmount totalAmount,
    AmountPaid amountPaid,
    Supplier supplier,
    FormzStatus status,
  }) {
    return TransactionState(
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      amountPaid: amountPaid ?? this.amountPaid,
      supplier: supplier ?? this.supplier,
      status: status ?? this.status,
    );
  }
}
