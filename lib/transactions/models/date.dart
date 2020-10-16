import 'package:formz/formz.dart';

enum DateValidationError { invalid }

class Date extends FormzInput<String, DateValidationError> {
  const Date.pure() : super.pure('');
  const Date.dirty([String value = '']) : super.dirty(value);

  static final RegExp _dateRegExp = RegExp(
    r'^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$',
  );

  @override
  DateValidationError validator(String value) {
    return _dateRegExp.hasMatch(value) ? null : DateValidationError.invalid;
  }
}
