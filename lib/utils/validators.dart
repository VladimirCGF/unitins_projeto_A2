class Validators {
  static String? email(String? value) {
    if (value == null || !value.contains('@')) {
      return 'Digite um e-mail válido';
    }
    return null;
  }
}
