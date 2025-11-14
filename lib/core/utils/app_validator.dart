class AppValidators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email cannot be empty";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }

  static String? firstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "First name cannot be empty";
    }
    return null;
  }

  static String? lastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Last name cannot be empty";
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number cannot be empty";
    }
    return null;
  }


  static String? confirmPassword(String? value, String newPassword) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm password cannot be empty";
    }

    if (value.trim() != newPassword.trim()) {
      return "Passwords do not match";
    }

    return null;
  }

}
