import 'package:equatable/equatable.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:ccm/transactions/models/models.dart';

abstract class FilteredTransactionsEvent extends Equatable {
  const FilteredTransactionsEvent();
}

class UpdateFilter extends FilteredTransactionsEvent {
  final VisibilityFilter filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class UpdateTransactions extends FilteredTransactionsEvent {
  final List<Transaction> transactions;

  const UpdateTransactions(this.transactions);

  @override
  List<Object> get props => [transactions];

  @override
  String toString() => 'UpdateTransactions { transactions: $transactions }';
}
