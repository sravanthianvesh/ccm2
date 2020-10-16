import 'package:bloc/bloc.dart';
import 'package:ccm/authentication/authentication.dart';
import 'package:ccm/transactions/models/category.dart';
import 'package:ccm/transactions/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:transactions_repository/transactions_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this._transactionRepository, this._authenticationBloc)
      : assert(_transactionRepository != null),
        assert(_authenticationBloc != null),
        super(const TransactionState());

  final TransactionRepository _transactionRepository;
  final AuthenticationBloc _authenticationBloc;

  void dateChanged(String value) {
    final date = Date.dirty(value);
    emit(state.copyWith(
      date: date,
      status: Formz.validate([date, state.category, state.description, state.quantity, state.totalAmount, state.amountPaid, state.supplier]),
    ));
  }

  void categoryChanged(String value) {
    final category = Category.dirty(value);
    emit(state.copyWith(
      category: category,
      status: Formz.validate([state.date, category, state.description, state.quantity, state.totalAmount, state.amountPaid, state.supplier]),
    ));
  }

  void descriptionChanged(String value) {
    final description = Description.dirty(value);
    emit(state.copyWith(
      description: description,
      status: Formz.validate([state.date, state.category, description, state.quantity, state.totalAmount, state.amountPaid, state.supplier]),
    ));
  }

  void quantityChanged(String value) {
    final quantity = Quantity.dirty(value);
    emit(state.copyWith(
      quantity: quantity,
      status: Formz.validate([state.date, state.category, state.description, quantity, state.totalAmount, state.amountPaid, state.supplier]),
    ));
  }

  void totalAmountChanged(String value) {
    final totalAmount = TotalAmount.dirty(value);
    emit(state.copyWith(
      totalAmount: totalAmount,
      status: Formz.validate([state.date, state.category, state.description, state.quantity, totalAmount, state.amountPaid, state.supplier]),
    ));
  }

  void amountPaidChanged(String value) {
    final amountPaid = AmountPaid.dirty(value);
    emit(state.copyWith(
      amountPaid: amountPaid,
      status: Formz.validate([state.date, state.category, state.description, state.quantity, state.totalAmount, amountPaid, state.supplier]),
    ));
  }

  void supplierChanged(String value) {
    final supplier = Supplier.dirty(value);
    emit(state.copyWith(
      supplier: supplier,
      status: Formz.validate([state.date, state.category, state.description, state.quantity, state.totalAmount, state.amountPaid, supplier]),
    ));
  }

  Future<void> transactionFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      Transaction newTransaction = Transaction(state.date.value, state.category.value, state.description.value, state.quantity.value, double.parse(state.totalAmount.value), double.parse(state.amountPaid.value), double.parse(state.totalAmount.value)  > double.parse(state.amountPaid.value), state.supplier.value, _authenticationBloc.state.user.id);

      await _transactionRepository.addNewTransaction(newTransaction);

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch(e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> transactionUpdateFormSubmitted(String id) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      Transaction transaction = Transaction(state.date.value, state.category.value, state.description.value, state.quantity.value, double.parse(state.totalAmount.value), double.parse(state.amountPaid.value), double.parse(state.totalAmount.value)  > double.parse(state.amountPaid.value), state.supplier.value, _authenticationBloc.state.user.id, id: id);

      await _transactionRepository.updateTransaction(transaction);

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch(e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

}
