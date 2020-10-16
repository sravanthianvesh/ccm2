import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:transactions_repository/transactions_repository.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final FirebaseTransactionRepository _transactionsRepository;
  StreamSubscription _transactionsSubscription;

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription _userSubscription;

  TransactionsBloc({
    @required FirebaseTransactionRepository transactionsRepository,
    @required AuthenticationRepository authenticationRepository,
  })
      : assert(transactionsRepository != null),
        _transactionsRepository = transactionsRepository,
        assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(TransactionsLoading()){
    _userSubscription = _authenticationRepository.user.listen(
          (user) {
        add(LoadTransactions(user));
      } ,
    );
  }

  @override
  Stream<TransactionsState> mapEventToState(TransactionsEvent event) async* {
    if (event is LoadTransactions) {
      yield* _mapLoadTransactionsToState(event.user);
    } else if (event is AddTransaction) {
      yield* _mapAddTransactionToState(event);
    } else if (event is UpdateTransaction) {
      yield* _mapUpdateTransactionToState(event);
    } else if (event is DeleteTransaction) {
      yield* _mapDeleteTransactionToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is TransactionsUpdated) {
      yield* _mapTransactionsUpdateToState(event);
    }
  }

  Stream<TransactionsState> _mapLoadTransactionsToState(User user) async* {
    if(user != User.empty){
      _transactionsSubscription?.cancel();
      _transactionsSubscription = _transactionsRepository.transactions(user.id).listen(
            (transactions) => add(TransactionsUpdated(transactions)),
      );
    }else{
      add(TransactionsUpdated(List<Transaction>()));
    }
  }

  Stream<TransactionsState> _mapAddTransactionToState(AddTransaction event) async* {
    _transactionsRepository.addNewTransaction(event.transaction);
  }

  Stream<TransactionsState> _mapUpdateTransactionToState(UpdateTransaction event) async* {
    _transactionsRepository.updateTransaction(event.updatedTransaction);
  }

  Stream<TransactionsState> _mapDeleteTransactionToState(DeleteTransaction event) async* {
    _transactionsRepository.deleteTransaction(event.transaction);
  }

  Stream<TransactionsState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TransactionsLoaded) {
      final allComplete = currentState.transactions.every((transaction) => transaction.incompletePayment);
      final List<Transaction> updatedTransactions = currentState.transactions
          .map((transaction) => transaction.copyWith(incompletePayment: !allComplete, amountPaid: transaction.amountPaid))
          .toList();
      updatedTransactions.forEach((updatedTransaction) {
        _transactionsRepository.updateTransaction(updatedTransaction);
      });
    }
  }

  Stream<TransactionsState> _mapTransactionsUpdateToState(TransactionsUpdated event) async* {
    yield TransactionsLoaded(event.transactions);
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
