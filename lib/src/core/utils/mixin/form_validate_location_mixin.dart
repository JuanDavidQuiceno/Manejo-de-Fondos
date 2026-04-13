mixin FormValidateLocationMixin {
  String? validateLocationAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Complete field to continue.';
    }
    if (value.trim().length < 5) {
      return 'Address must contain at least 5 characters.';
    }
    if (value.length > 150) {
      return 'Address cannot exceed 150 characters.';
    }
    return null;
  }

  // Valida el campo City: mínimo 3, máximo 100 caracteres
  String? validateLocationCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Complete field to continue.';
    }
    if (value.trim().length < 3) {
      return 'City must contain at least 3 characters.';
    }
    if (value.length > 100) {
      return 'City cannot exceed 100 characters.';
    }
    return null;
  }

  /// Valida el campo State: mínimo 3, máximo 50 caracteres
  String? validateLocationState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Complete field to continue.';
    }
    if (value.trim().length < 3) {
      return 'State must contain at least 3 characters.';
    }
    if (value.length > 50) {
      return 'State cannot exceed 50 characters.';
    }
    return null;
  }

  /// Valida el campo Country: mínimo 3, máximo 50 caracteres
  String? validateLocationCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Complete field to continue.';
    }
    if (value.trim().length < 3) {
      return 'Country must contain at least 3 characters.';
    }
    if (value.length > 50) {
      return 'Country cannot exceed 50 characters.';
    }
    return null;
  }

  /// Valida el campo Zip Code: entre 3 y 12 caracteres
  String? validateLocationZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Complete field to continue.';
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length < 3) {
      return 'Zip code must contain at least 3 characters.';
    }
    if (trimmedValue.length > 12) {
      return 'Zip code cannot exceed 12 characters.';
    }
    return null;
  }

  bool isValid({
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) {
    // validamos que los campos requeridos no sean nulos y pasen validación
    final isValid =
        validateLocationAddress(address) == null &&
        validateLocationCity(city) == null &&
        validateLocationState(state) == null &&
        validateLocationZipCode(zipCode) == null;

    return isValid;
  }
}
