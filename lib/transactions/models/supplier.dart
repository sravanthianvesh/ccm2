import 'package:formz/formz.dart';

enum SupplierValidationError { invalid }

class Supplier extends FormzInput<String, SupplierValidationError> {
  const Supplier.pure() : super.pure('');
  const Supplier.dirty([String value = '']) : super.dirty(value);

  static final RegExp _sentenceRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+\s\/=?^_`{|}~-]+$',
  );

  @override
  SupplierValidationError validator(String value) {
    return _sentenceRegExp.hasMatch(value) ? null : SupplierValidationError.invalid;
  }
}
