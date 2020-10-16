import 'package:formz/formz.dart';

enum AmountPaidValidationError { invalid }

class AmountPaid extends FormzInput<String, AmountPaidValidationError> {
  const AmountPaid.pure() : super.pure('');
  const AmountPaid.dirty([String value = '']) : super.dirty(value);

  static final RegExp _currencyRegExp = RegExp(
    r'^(\d+)(\.\d{1,2})?$',
  );

  @override
  AmountPaidValidationError validator(String value) {
    return _currencyRegExp.hasMatch(value) ? null : AmountPaidValidationError.invalid;
  }
}
