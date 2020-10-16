import 'package:equatable/equatable.dart';

import 'package:transactions_repository/transactions_repository.dart';
import 'package:ccm/transactions/models/models.dart';

abstract class FilteredTransactionsState extends Equatable {
  const FilteredTransactionsState();

  @override
  List<Object> get props => [];
}

class FilteredTransactionsLoading extends FilteredTransactionsState {}

class FilteredTransactionsLoaded extends FilteredTransactionsState {
  final List<Transaction> filteredTransactions;
  final VisibilityFilter completedFilter;

  const FilteredTransactionsLoaded(
      this.filteredTransactions,
      this.completedFilter,
      );

  @override
  List<Object> get props => [filteredTransactions, completedFilter];

  @override
  String toString() {
    return 'FilteredTransactionsLoaded { filteredTransactions: $filteredTransactions, activeFilter: $completedFilter }';
  }
}
