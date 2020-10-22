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
            title: Text('Transaction Details'),
            actions: [
              transaction.incompletePayment ?
              IconButton(
                tooltip: 'Clear Dues/Advances',
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
          body: Column(
            children: [
              Card(
                margin: EdgeInsets.all(12.0),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date:',
                        style:
                        Theme.of(context).textTheme.subtitle1,
                      ),

                      const SizedBox(height: 8.0,),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.blue[900],
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              transaction.date,
                              style:
                              Theme.of(context).textTheme.subtitle1,
                            ),
                          ]
                        ),
                      ),

                      const SizedBox(height: 16.0,),

                      Text(
                        'Category:',
                        style:
                        Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8.0,),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.category,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 8.0,),
                              Text(
                                transaction.category,
                                style:
                                Theme.of(context).textTheme.subtitle1,
                                maxLines: 5,
                              ),
                            ]
                        ),
                      ),

                      const SizedBox(height: 8.0,),

                      Text(
                        'Description:',
                        style:
                        Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8.0,),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.description,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 8.0,),
                              Text(
                                transaction.description,
                                style:
                                Theme.of(context).textTheme.subtitle1,
                                maxLines: 5,
                              ),
                            ]
                        ),
                      ),

                      const SizedBox(height: 8.0,),

                      Text(
                        'Quantity:',
                        style:
                        Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8.0,),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.view_list,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 8.0,),
                              Text(
                                transaction.quantity,
                                style:
                                Theme.of(context).textTheme.subtitle1,
                              ),
                            ]
                        ),
                      ),

                      const SizedBox(height: 8.0,),

                      Text(
                        'Billed Amount:',
                        style:
                        Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8.0,),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 8.0,),
                              Text(
                                transaction.totalAmount.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ]
                        ),
                      ),

                      const SizedBox(height: 16.0,),

                      transaction.amountPaid != transaction.totalAmount ?
                      Text(
                        transaction.incompletePayment ? 'Due:' : 'Advance:',
                        style:
                        Theme.of(context).textTheme.subtitle1,
                      ) :
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.blue[900],
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              'Paid',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ]
                      ),

                      const SizedBox(height: 8.0,),
                      transaction.amountPaid != transaction.totalAmount ?
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                transaction.incompletePayment ? Icons.money_off : Icons.attach_money,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 8.0,),
                              Text(
                                transaction.amountPaid.toStringAsFixed(2),
                                style: GoogleFonts.openSans(
                                  textStyle: Theme.of(context).textTheme.subtitle1,
                                  color: transaction.incompletePayment ? Colors.red : Colors.green[600],
                                ),
                              ),
                            ]
                        ),
                      ) :
                      Container(),
                    ],
                  ),
                ),
              ),
            ],
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
