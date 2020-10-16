import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccm/transactions/bloc/stats.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:ccm/transactions/models/chart_data_sets.dart';
import 'package:transactions_repository/transactions_repository.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StreamSubscription _transactionsSubscription;

  StatsBloc({TransactionsBloc transactionsBloc})
      : assert(transactionsBloc != null),
        super(StatsLoading()) {
    _transactionsSubscription = transactionsBloc.listen((state) {
      if (state is TransactionsLoaded) {
        add(UpdateStats(state.transactions));
      }
    });
  }

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is UpdateStats) {
      List<Transaction> transactions = event.transactions.toList();
      double paid = 0.00;
      double due = 0.00;
      double advances = 0.00;
      double totalPaid = 0.00;
      double billed = 0.00;
      List<LinearExpenditure> chartData = [];
      var chartDataMap = {};

     for(final transact in transactions){

       if(transact.amountPaid < transact.totalAmount){
         due += transact.totalAmount - transact.amountPaid;
       }else if(transact.amountPaid > transact.totalAmount){
         advances += transact.amountPaid - transact.totalAmount;
       }else{
         paid += transact.amountPaid;
       }

       totalPaid += transact.amountPaid;
       billed += transact.totalAmount;

       chartDataMap.containsKey(transact.category) ? chartDataMap[transact.category] += transact.totalAmount : chartDataMap[transact.category] = transact.totalAmount;
     }

     chartDataMap.forEach((key, value) {
        chartData.add(LinearExpenditure(key, value));
      });

      yield StatsLoaded(billed, totalPaid, advances, paid, due, chartData);
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
