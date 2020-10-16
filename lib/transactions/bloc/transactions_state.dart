import 'package:equatable/equatable.dart';
import 'package:transactions_repository/transactions_repository.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<Transaction> transactions;

  const TransactionsLoaded([this.transactions = const []]);

  @override
  List<Object> get props => [transactions];

  @override
  String toString() => 'TransactionsLoaded { transactions: $transactions }';
}

class TransactionsNotLoaded extends TransactionsState {}
