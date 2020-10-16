import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:ccm/transactions/views/screens.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  DetailsScreen({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        final transaction = (state as TransactionsLoaded)
            .transactions
            .firstWhere((transaction) => transaction.id == id, orElse: () => null);
        return Scaffold(
          appBar: AppBar(
            title: Text(transaction?.category ?? 'Transaction Details'),
            actions: [
              transaction.incompletePayment ?
              IconButton(
                tooltip: 'Mrk Paid',
                icon: Icon(Icons.check_box),
                onPressed: () {
                  BlocProvider.of<TransactionsBloc>(context).add(UpdateTransaction(transaction.copyWith(amountPaid: transaction.totalAmount, incompletePayment: false)));
                  Navigator.pop(context, transaction);
                },
              )
                  :
              IconButton(
                tooltip: 'No Dues',
                icon: Icon(Icons.done),
                onPressed: null,
              ),

              IconButton(
                tooltip: 'Delete Transaction',
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<TransactionsBloc>(context).add(DeleteTransaction(transaction));
                  Navigator.pop(context, transaction);
                },
              )
            ],
          ),
          body: transaction == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8.0,),
                                  Text(
                                    transaction.date,
                                    style:
                                    Theme.of(context).textTheme.bodyText1,
                                  ),
                                ]
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8.0,),

                          Card(
                            child: Container(

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.description,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8.0,),
                                    Text(
                                      transaction.description,
                                      style:
                                      Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ]
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.grey),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8.0,),

                          Card(
                            child: Container(

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.view_list,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8.0,),
                                    Text(
                                      transaction.quantity,
                                      style:
                                      Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ]
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.grey),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8.0,),

                          Card(
                            child: Container(

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8.0,),
                                    Text(
                                      transaction.totalAmount.toStringAsFixed(2),
                                      style: GoogleFonts.openSans(
                                        textStyle: Theme.of(context).textTheme.bodyText1,
                                        color: const Color(0xFF33691E),
                                      ),
                                    ),
                                  ]
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.grey),

                              ),
                            ),
                          ),

                          const SizedBox(height: 8.0,),
                          transaction.incompletePayment ?
                          Card(
                            child: Container(

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.money_off,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8.0,),
                                    Text(
                                      transaction.amountPaid.toStringAsFixed(2),
                                      style: GoogleFonts.openSans(
                                        textStyle: Theme.of(context).textTheme.bodyText1,
                                        color: const Color(0xFFFF7043),
                                      ),
                                    ),
                                  ]
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.grey),
                              ),
                            ),
                          ) :
                          transaction.amountPaid > transaction.totalAmount ?
                          Card(
                            child: Container(

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8.0,),
                                    Text(
                                      transaction.amountPaid.toStringAsFixed(2),
                                      style: GoogleFonts.openSans(
                                        textStyle: Theme.of(context).textTheme.bodyText1,
                                        color: const Color(0xFFFFB74D),
                                      ),
                                    ),
                                  ]
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: .5, color: Colors.grey),

                              ),
                            ),
                          ) :

                          Container(),
                        ],
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Edit Transaction',
            child: Icon(Icons.edit),
            onPressed: transaction == null
                ? null
                : () {
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
                  },
          ),
        );
      },
    );
  }
}
