class Validator {
  static String? validateEmptyText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Необходимо заполнить поле';
    }
    return null;
  }

  /// Phone Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Необходимо заполнить поле';
    }
    return null;
  }
}
