import 'package:formz/formz.dart';

enum CategoryValidationError { invalid }

class Category extends FormzInput<String, CategoryValidationError> {
  const Category.pure() : super.pure('');
  const Category.dirty([String value = '']) : super.dirty(value);

  static final RegExp _sentenceRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+\s\/=?^_`{|}~-]+$',
  );

  @override
  CategoryValidationError validator(String value) {
    return _sentenceRegExp.hasMatch(value) ? null : CategoryValidationError.invalid;
  }
}
