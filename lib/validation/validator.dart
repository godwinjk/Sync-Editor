String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  // Basic email pattern
  const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(emailPattern);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 4) {
    return 'Password must be at least 4 characters';
  }
  // if (!RegExp(r'[A-Z]').hasMatch(value)) {
  //   return 'Password must contain at least one uppercase letter';
  // }
  // if (!RegExp(r'[a-z]').hasMatch(value)) {
  //   return 'Password must contain at least one lowercase letter';
  // }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one number';
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'Password must contain at least one special character';
  }
  return null;
}
