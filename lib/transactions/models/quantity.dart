import 'package:formz/formz.dart';

enum QuantityValidationError { invalid }

class Quantity extends FormzInput<String, QuantityValidationError> {
  const Quantity.pure() : super.pure('');
  const Quantity.dirty([String value = '']) : super.dirty(value);

  static final RegExp _sentenceRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+\s\/=?^_`{|}~-]+$',
  );

  @override
  QuantityValidationError validator(String value) {
    return _sentenceRegExp.hasMatch(value) ? null : QuantityValidationError.invalid;
  }
}
