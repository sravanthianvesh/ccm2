import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:ccm/transactions/models/models.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:ccm/transactions/bloc/filtered_transactions.dart';

class FilteredTransactionsBloc extends Bloc<FilteredTransactionsEvent, FilteredTransactionsState> {
  final TransactionsBloc _transactionsBloc;
  StreamSubscription _transactionsSubscription;

  FilteredTransactionsBloc({@required TransactionsBloc transactionsBloc})
      : assert(transactionsBloc != null),
        _transactionsBloc = transactionsBloc,
        super(transactionsBloc.state is TransactionsLoaded
          ? FilteredTransactionsLoaded(
        (transactionsBloc.state as TransactionsLoaded).transactions,
        VisibilityFilter.all,
      )
          : FilteredTransactionsLoading()) {
    _transactionsSubscription = transactionsBloc.listen((state) {
      if (state is TransactionsLoaded) {
        add(UpdateTransactions((transactionsBloc.state as TransactionsLoaded).transactions));
      }
    });
  }

  @override
  Stream<FilteredTransactionsState> mapEventToState(FilteredTransactionsEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateTransactions) {
      yield* _mapTransactionsUpdatedToState(event);
    }
  }

  Stream<FilteredTransactionsState> _mapUpdateFilterToState(
      UpdateFilter event,
      ) async* {
    final currentState = _transactionsBloc.state;
    if (currentState is TransactionsLoaded) {
      yield FilteredTransactionsLoaded(
        _mapTransactionsToFilteredTransactions(currentState.transactions, event.filter),
        event.filter,
      );
    }
  }

  Stream<FilteredTransactionsState> _mapTransactionsUpdatedToState(
      UpdateTransactions event,
      ) async* {
    final visibilityFilter = state is FilteredTransactionsLoaded
        ? (state as FilteredTransactionsLoaded).completedFilter
        : VisibilityFilter.all;
    yield FilteredTransactionsLoaded(
      _mapTransactionsToFilteredTransactions(
        (_transactionsBloc.state as TransactionsLoaded).transactions,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Transaction> _mapTransactionsToFilteredTransactions(
      List<Transaction> transactions, VisibilityFilter filter) {
    return transactions.where((transaction) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.due) {
        return transaction.incompletePayment;
      } else if (filter == VisibilityFilter.paid) {
        return !transaction.incompletePayment;
      }else{
        return transaction.amountPaid > transaction.totalAmount;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
