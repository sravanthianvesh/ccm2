import 'package:formz/formz.dart';

enum DescriptionValidationError { invalid }

class Description extends FormzInput<String, DescriptionValidationError> {
  const Description.pure() : super.pure('');
  const Description.dirty([String value = '']) : super.dirty(value);

  static final RegExp _sentenceRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+\s\/=?^_`{|}~-]+$',
  );

  @override
  DescriptionValidationError validator(String value) {
    return _sentenceRegExp.hasMatch(value) ? null : DescriptionValidationError.invalid;
  }
}
