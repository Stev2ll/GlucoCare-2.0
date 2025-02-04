class TValidator {
  static String? validateText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return 'Tu $fieldName es requerido';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio.';
    }

    return null;
  }

  static String? validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nombre es obligatorio.';
    }
    return null;
  }

  static String? validateApellido(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido es obligatorio.';
    }
    return null;
  }

  static String? validateContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }

    // Verificar si contiene letras mayúsculas
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una letra mayúscula.';
    }

    // Verificar si contiene números
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número.';
    }

    // Verificar si contiene caracteres especiales
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial.';
    }

    return null;
  }

  static String? validateFechaNacimiento(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha de nacimiento es obligatoria.';
    }

    // Verificar si la fecha de nacimiento tiene el formato correcto (dd/mm/yyyy)
    final dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegExp.hasMatch(value)) {
      return 'Formato de fecha inválido (yyyy-mm-dd).';
    }

    return null;
  }

  static String? validateGenero(String? value) {
    if (value == null || value.isEmpty) {
      return 'El género es obligatorio.';
    }
    return null;
  }

  static String? validatePeso(String? value) {
    if (value == null || value.isEmpty) {
      return 'El peso es obligatorio.';
    }

    // Verificar si el peso es un número válido
    if (double.tryParse(value) == null) {
      return 'El peso debe ser un número válido.';
    }

    return null;
  }

  static String? validateAltura(String? value) {
    if (value == null || value.isEmpty) {
      return 'La altura es obligatoria.';
    }

    // Verificar si la altura es un número válido
    if (double.tryParse(value) == null) {
      return 'La altura debe ser un número válido.';
    }

    return null;
  }
}
