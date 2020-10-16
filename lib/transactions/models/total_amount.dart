import 'package:formz/formz.dart';

enum TotalAmountValidationError { invalid }

class TotalAmount extends FormzInput<String, TotalAmountValidationError> {
  const TotalAmount.pure() : super.pure('');
  const TotalAmount.dirty([String value = '']) : super.dirty(value);

  static final RegExp _currencyRegExp = RegExp(
    r'^(\d+)(\.\d{1,2})?$',
  );

  @override
  TotalAmountValidationError validator(String value) {
    return _currencyRegExp.hasMatch(value) ? null : TotalAmountValidationError.invalid;
  }
}
