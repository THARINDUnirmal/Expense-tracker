String exceptions(String errorCode) {
  switch (errorCode) {
    // LOGIN ERRORS
    case 'invalid-email':
      return 'The email format is invalid.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
      return 'No user found with this email.';
    case 'wrong-password':
      return 'Incorrect password. Please try again.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';

    // REGISTER ERRORS
    case 'email-already-in-use':
      return 'This email is already registered.';
    case 'operation-not-allowed':
      return 'Email/password login is not enabled in Firebase.';
    case 'weak-password':
      return 'Your password is too weak. Please choose a stronger one.';

    // CREDENTIAL ERRORS (RARE IN EMAIL LOGIN)
    case 'account-exists-with-different-credential':
      return 'Email already linked to another login method.';
    case 'invalid-credential':
      return 'Invalid email or password. Try again.';

    // PHONE/OTP ERRORS (only if you use phone auth)
    case 'invalid-verification-code':
      return 'The verification code is invalid.';
    case 'invalid-verification-id':
      return 'Invalid verification ID.';
    case 'expired-action-code':
      return 'The verification code has expired.';

    // USER MISMATCH (re-auth cases)
    case 'user-mismatch':
      return 'This credential does not match the current user.';

    // FALLBACK
    default:
      return 'Something went wrong. Please try again.';
  }
}
