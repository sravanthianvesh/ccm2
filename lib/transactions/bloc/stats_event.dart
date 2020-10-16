import 'package:equatable/equatable.dart';
import 'package:transactions_repository/transactions_repository.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}

class UpdateStats extends StatsEvent {
  final List<Transaction> transactions;

  const UpdateStats(this.transactions);

  @override
  List<Object> get props => [transactions];

  @override
  String toString() => 'UpdateStats { transactions: $transactions }';
}
