import 'package:formz/formz.dart';

enum IncompletePaymentValidationError { invalid }

class IncompletePayment extends FormzInput<bool, IncompletePaymentValidationError> {
  const IncompletePayment.pure() : super.pure(false);
  const IncompletePayment.dirty([bool value = false]) : super.dirty(value);

  static final RegExp _boolRegExp = RegExp(
    r'^(true|false|1|0|True|False|TRUE|FALSE)$',
  );

  @override
  IncompletePaymentValidationError validator(bool value) {
    return _boolRegExp.hasMatch(value.toString()) ? null : IncompletePaymentValidationError.invalid;
  }
}
