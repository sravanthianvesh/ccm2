import 'package:ccm/transactions/models/chart_data_sets.dart';
import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final double billed;
  final double totalPaid;
  final double paid;
  final double due;
  final double advances;
  final List<LinearExpenditure> chartData;

  const StatsLoaded(this.billed, this.totalPaid, this.advances, this.paid, this.due, this.chartData);

  @override
  List<Object> get props => [billed, totalPaid, advances, paid, due, chartData];

  @override
  String toString() {
    return 'StatsLoaded { Billed: $billed, Total Paid: $totalPaid, Advances: $advances, Paid: $paid, Due: $due, Chart Data: $chartData }';
  }
}
