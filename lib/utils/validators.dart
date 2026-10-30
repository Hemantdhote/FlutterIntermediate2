class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegExp.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? url(String? value, {String fieldName = 'image URL'}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Please enter $fieldName';
    }
    final uri = Uri.tryParse(text);
    if (uri == null || !uri.hasAuthority || !['http', 'https'].contains(uri.scheme)) {
      return 'Please enter a valid HTTP/HTTPS URL';
    }
    return null;
  }
}

