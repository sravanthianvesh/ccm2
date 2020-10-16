import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/transactions/bloc/filtered_transactions.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:ccm/transactions/views/screens.dart';
import 'package:ccm/widgets/widgets.dart';

class FilteredTransactions extends StatelessWidget {
  FilteredTransactions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredTransactionsBloc, FilteredTransactionsState>(
      builder: (context, state) {
        if (state is FilteredTransactionsLoading) {
          return LoadingIndicator();
        } else if (state is FilteredTransactionsLoaded) {
          final transactions = state.filteredTransactions;
          return ListView.builder(
            padding: EdgeInsets.all(4.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionItem(
                transaction: transaction,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    BlocProvider.of<TransactionsBloc>(context).add(
                        UpdateTransaction(transaction.copyWith(amountPaid: transaction.totalAmount, incompletePayment: false)));
                    Scaffold.of(context).showSnackBar(DeleteTransactionSnackBar(
                        transaction: transaction,
                        onUndo: () =>
                            BlocProvider.of<TransactionsBloc>(context).add(
                                AddTransaction(transaction.copyWith(amountPaid: transaction.amountPaid, incompletePayment: transaction.incompletePayment)))
                    ));
                  } else if (direction == DismissDirection.endToStart) {
                    BlocProvider.of<TransactionsBloc>(context).add(
                        DeleteTransaction(transaction));
                    Scaffold.of(context).showSnackBar(DeleteTransactionSnackBar(
                        transaction: transaction,
                        onUndo: () =>
                            BlocProvider.of<TransactionsBloc>(context).add(
                                AddTransaction(transaction))
                    ));
                  }
                },

                onTap: () async {
                  final removedTransaction = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return DetailsScreen(id: transaction.id);
                    }),
                  );
                  if (removedTransaction != null) {
                    Scaffold.of(context).showSnackBar(
                      DeleteTransactionSnackBar(
                        transaction: transaction,
                        onUndo: () => BlocProvider.of<TransactionsBloc>(context)
                            .add(AddTransaction(transaction)),
                      ),
                    );
                  }
                },
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
