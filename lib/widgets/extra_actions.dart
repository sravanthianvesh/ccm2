import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:ccm/transactions/models/models.dart';

class ExtraActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state is TransactionsLoaded) {
          bool allComplete = state.transactions.every((transaction) => transaction.incompletePayment);
          return PopupMenuButton<ExtraAction>(
            onSelected: (action) {
              switch (action) {
                case ExtraAction.toggleAllComplete:
                  BlocProvider.of<TransactionsBloc>(context).add(ToggleAll());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
              PopupMenuItem<ExtraAction>(
                value: ExtraAction.toggleAllComplete,
                child: Text(
                    allComplete ? 'Mark all incomplete' : 'Mark all complete'),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
