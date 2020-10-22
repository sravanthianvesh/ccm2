import 'package:ccm/transactions/bloc/stats.dart';
import 'package:ccm/widgets/slidable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/transactions/bloc/filtered_transactions.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:ccm/transactions/views/screens.dart';
import 'package:ccm/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

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

          //BlocProvider.of<StatsBloc>(context).add(UpdateStats(transactions));
          
          final stats = BlocProvider.of<StatsBloc>(context).state is StatsLoaded ? BlocProvider.of<StatsBloc>(context).state as StatsLoaded : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Billed:',
                                  style: GoogleFonts.openSans(
                                    textStyle: Theme.of(context).textTheme.headline6,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                SizedBox(height: 4.0,),
                                Text(
                                  '${stats?.billed ?? '-'}',
                                  style: GoogleFonts.openSans(
                                    textStyle: Theme.of(context).textTheme.headline5,
                                    color: const Color(0xFFFF7043),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),

                    Expanded(
                      child: Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Paid:',
                                  style: GoogleFonts.openSans(
                                    textStyle: Theme.of(context).textTheme.headline6,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                SizedBox(height: 4.0,),
                                Text(
                                  '${stats?.paid ?? '-'}',
                                  style: GoogleFonts.openSans(
                                    textStyle: Theme.of(context).textTheme.headline5,
                                    color: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.segment,
                      color: Colors.blue[900],
                    ),
                    SizedBox(width: 8.0,),
                    Text(
                      'Transactions',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.headline5,
                        color: Colors.blue[900],
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return TransactionItem(
                    transaction: transaction,
                    onDismissed: (action) {
                      if (action == SlidableAction.complete) {
                        BlocProvider.of<TransactionsBloc>(context).add(
                            UpdateTransaction(transaction.copyWith(amountPaid: transaction.totalAmount, incompletePayment: false)));
                        Scaffold.of(context).showSnackBar(CompleteTransactionSnackBar(
                            transaction: transaction,
                            onUndo: () =>
                                BlocProvider.of<TransactionsBloc>(context).add(
                                    AddTransaction(transaction.copyWith(amountPaid: transaction.amountPaid, incompletePayment: transaction.incompletePayment)))
                        ));
                      } else if (action == SlidableAction.delete) {
                        BlocProvider.of<TransactionsBloc>(context).add(
                            DeleteTransaction(transaction));
                        Scaffold.of(context).showSnackBar(DeleteTransactionSnackBar(
                            transaction: transaction,
                            onUndo: () =>
                                BlocProvider.of<TransactionsBloc>(context).add(
                                    AddTransaction(transaction))
                        ));
                      } else if(action == SlidableAction.edit){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddEditPage(
                                isEditing: true,
                                transaction: transaction,
                              );
                            },
                          ),
                        );
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
              ),
            ),
            ]
          );
        } else {
          return Container();
        }
      },
    );
  }
}
