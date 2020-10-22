import 'package:ccm/authentication/authentication.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ccm/transactions/cubit/transaction_cubit.dart';
import 'package:intl/intl.dart';
import 'package:transactions_repository/transactions_repository.dart';

class AddEditForm extends StatelessWidget {
  const AddEditForm({
    Key key,
    bool isEditing,
    this.transaction,
  }) : isEditing = isEditing?? false,
        super(key: key);

  final bool isEditing;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(
                  isEditing ? 'Transaction Update Failure'
              : 'Transaction Addition Failure')),
            );
        } else if(state.status.isSubmissionSuccess){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(
                  isEditing ? 'Transaction updated'
                      : 'Transaction saved.')),
            );
          BlocProvider.of<TransactionsBloc>(context).add(LoadTransactions(BlocProvider.of<AuthenticationBloc>(context).state.user));
          Navigator.of(context).pop();
        }
        context.bloc<TransactionCubit>().categoryChanged(state.category.value.length > 0 ? state.category.value : transaction?.category ?? 'Cement');

        context.bloc<TransactionCubit>().descriptionChanged(state.description.value.length > 0 ? state.description.value : transaction?.description ?? '');

        context.bloc<TransactionCubit>().quantityChanged(state.quantity.value.length > 0 ? state.quantity.value : transaction?.quantity ?? '');

        context.bloc<TransactionCubit>().totalAmountChanged(state.totalAmount.value.length > 0 ? state.totalAmount.value : transaction?.totalAmount?.toStringAsFixed(2) ?? '');

        context.bloc<TransactionCubit>().amountPaidChanged(state.amountPaid.value.length > 0 ? state.amountPaid.value : transaction?.amountPaid?.toStringAsFixed(2) ?? '');

        context.bloc<TransactionCubit>().supplierChanged(state.supplier.value.length > 0 ? state.supplier.value : transaction?.supplier ?? '');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DateInput(transaction?.date ?? ''),
              const SizedBox(height: 8.0),
              _CategoryInput(transaction?.category?? null),
              const SizedBox(height: 8.0),
              _DescriptionInput(transaction?.description?? ''),
              const SizedBox(height: 8.0),
              _QuantityInput(transaction?.quantity?? null),
              const SizedBox(height: 8.0),
              _TotalAmountInput(transaction?.totalAmount?? null),
              /*const SizedBox(height: 8.0),
              _IncompletePaymentInput(transaction?.incompletePayment?? null),*/
              const SizedBox(height: 8.0),
              _AmountPaidInput(transaction?.amountPaid?? null),
              const SizedBox(height: 8.0),
              _SupplierInput(transaction?.supplier?? null),
              const SizedBox(height: 8.0),
              _AddEditButton(isEditing?? false, transaction),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateInput extends StatefulWidget {
  _DateInput(this.init);

  final String init;
  @override
  _DateInputState createState() => _DateInputState(init);
}

class _DateInputState extends State<_DateInput> {
  _DateInputState(this.init);

  final String init;

  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    dateCtl.text = init != '' ? init : DateFormat("dd-MM-yyyy").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        DateTime initDate = init != '' ? DateTime(int.parse(init.substring(6,10)),int.parse(init.substring(3,5)),int.parse(init.substring(0,2))) : DateTime.now();
        context.bloc<TransactionCubit>().dateChanged(dateCtl.text);
        return TextFormField(
          key: const Key('addEditForm_dateInput_datePicker'),
          controller: dateCtl,
          readOnly: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            DateTime date = await showDatePicker(
              context: context,
              initialDate: initDate,
              firstDate: DateTime(1947),
              lastDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.calendar,
              fieldLabelText: 'Category',
              fieldHintText: '',
              errorInvalidText: state.category.invalid ? 'invalid category' : null,
            );
            setState(() {
              dateCtl.text = DateFormat("dd-MM-yyyy").format(date);
            });
          },
        );
      },
    );
  }
}

class _CategoryInput extends StatelessWidget {
  _CategoryInput(this.init);

  final String init;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.category != current.category,
      builder: (context, state) {
        return DropdownButtonFormField(
          key: const Key('addEditForm_categoryInput_dropDownButtonFormField'),
          items: <String>['Architect & Structural Consulting',
            'Plan & Approvals',
            'Earth Work Cutting',
            'Earth Work Filling',
            'Bore Well',
            'Cement',
            'Fine Aggregate - Sand',
            'Fine Aggregate - Quarry Dust',
            'Coarse Aggregate (Metal)',
            'Steel',
            'Wood',
            'Electrical',
            'Flooring',
            'Plumbing',
            'Painting',
            'Others'
          ]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: init ?? 'Cement',
          onChanged: (category) => context.bloc<TransactionCubit>().categoryChanged(category),
          decoration: InputDecoration(
            labelText: 'Category',
            helperText: '',
            errorText: state.category.invalid ? 'invalid category' : null,
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  _DescriptionInput(this.init);

  final String init;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
          key: const Key('addEditForm_descriptionInput_textField'),
          onChanged: (description) {
            description != '' ? context.bloc<TransactionCubit>().descriptionChanged(description) : null;
          },
          keyboardType: TextInputType.text,
          initialValue: init ?? '',
          decoration: InputDecoration(
            labelText: 'Description',
            helperText: '',
            errorText: state.description.invalid ? 'invalid description' : null,
          ),
        );
      },
    );
  }
}

class _QuantityInput extends StatelessWidget {
  _QuantityInput(this.init);

  final String init;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.quantity != current.quantity,
      builder: (context, state) {
        return TextFormField(
          key: const Key('addEditForm_quantityInput_textField'),
          onChanged: (quantity) =>
              context.bloc<TransactionCubit>().quantityChanged(quantity),
          keyboardType: TextInputType.text,
          initialValue: init ?? '',
          decoration: InputDecoration(
            labelText: 'Quantity',
            helperText: '',
            errorText: state.quantity.invalid ? 'invalid quantity' : null,
          ),
        );
      },
    );
  }
}

class _TotalAmountInput extends StatelessWidget {
  _TotalAmountInput(this.init);

  final double init;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.totalAmount != current.totalAmount,
      builder: (context, state) {
        return TextFormField(
          key: const Key('addEditForm_totalAmountInput_textField'),
          onChanged: (totalAmount) =>
              context.bloc<TransactionCubit>().totalAmountChanged(totalAmount),
          keyboardType: TextInputType.number,
          initialValue: init?.toStringAsFixed(2) ?? '',
          decoration: InputDecoration(
            labelText: 'Total Amount',
            helperText: '',
            errorText: state.totalAmount.invalid ? 'invalid Total Amount' : null,
          ),
        );
      },
    );
  }
}

class _AmountPaidInput extends StatelessWidget {
  _AmountPaidInput(this.init);

  final double init;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.amountPaid != current.amountPaid,
      builder: (context, state) {
        return TextFormField(
          key: const Key('addEditForm_amountPaidInput_textField'),
          onChanged: (amountPaid) =>
              context.bloc<TransactionCubit>().amountPaidChanged(amountPaid),
          keyboardType: TextInputType.number,
          initialValue: init?.toStringAsFixed(2) ?? '',
          decoration: InputDecoration(
            labelText: 'Amount Paid',
            helperText: '',
            errorText: state.amountPaid.invalid ? 'invalid Amount Paid' : null,
          ),
        );
      },
    );
  }
}

/*class _IncompletePaymentInput extends StatelessWidget {
  _IncompletePaymentInput(this.init);

  final bool init;

  @override
  Widget build(BuildContext context) {
    bool _groupValue = init?? false;
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.incompletePayment != current.incompletePayment,
      builder: (context, state) {
        context.bloc<TransactionCubit>().incompletePaymentChanged(init?? false);
        return RadioListTile(
          key: const Key('addEditForm_incompletePaymentInput_radioButton'),
          onChanged: (incompletePayment) =>
              context.bloc<TransactionCubit>().incompletePaymentChanged(incompletePayment),
          value: true,
          title: Text('Incomplete Payment?'),
          activeColor: Colors.green,
          groupValue: state.incompletePayment,
        );
      },
    );
  }
}*/

class _SupplierInput extends StatelessWidget {
  _SupplierInput(this.init);

  final String init;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.supplier != current.supplier,
      builder: (context, state) {
        return TextFormField(
          key: const Key('addEditForm_supplierInput_textField'),
          onChanged: (supplier) =>
              context.bloc<TransactionCubit>().supplierChanged(supplier),
          keyboardType: TextInputType.text,
          initialValue: init ?? '',
          decoration: InputDecoration(
            labelText: 'Supplier',
            helperText: '',
            errorText: state.supplier.invalid ? 'invalid supplier' : null,
          ),
        );
      },
    );
  }
}

class _AddEditButton extends StatelessWidget {
  _AddEditButton(this.isEditing, this.transaction);

  final bool isEditing;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('addEditForm_continue_raisedButton'),
                child: const Text('SAVE'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.orangeAccent,
                onPressed: state.status.isValidated
                    ? () => isEditing ? context.bloc<TransactionCubit>().transactionUpdateFormSubmitted(transaction.id) : context.bloc<TransactionCubit>().transactionFormSubmitted()
                    : null,
              );
      },
    );
  }
}
