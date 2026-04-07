class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    final regex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Email invalido';
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo requerido';
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.length != 6) return 'PIN de 6 digitos';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return 'Solo numeros';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.replaceAll(RegExp(r'[\s\-\+]'), '').length < 7) {
      return 'Telefono invalido';
    }
    return null;
  }
}
