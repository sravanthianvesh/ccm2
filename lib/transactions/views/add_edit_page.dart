import 'package:ccm/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/transactions/cubit/transaction_cubit.dart';
import 'package:transactions_repository/transactions_repository.dart';
import 'package:ccm/transactions/views/screens.dart';

class AddEditPage extends StatelessWidget {
  const AddEditPage({
    Key key,
    bool isEditing,
    this.transaction,
  }) : isEditing = isEditing?? false,
        super(key: key);

  final bool isEditing;
  final Transaction transaction;
  //const AddEditPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AddEditPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        isEditing ? 'Edit Transaction' : 'Add Transaction'
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<TransactionCubit>(
          create: (_) => TransactionCubit(
            context.repository<FirebaseTransactionRepository>(),
            context.bloc<AuthenticationBloc>(),
          ),
          child: SingleChildScrollView(child: AddEditForm(isEditing: isEditing, transaction: transaction)),
        ),
      ),
    );
  }
}
