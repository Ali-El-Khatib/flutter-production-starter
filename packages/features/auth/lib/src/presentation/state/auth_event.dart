/// Base class for all authentication events.
sealed class AuthEvent {}

/// Check if a valid session exists in secure storage.
class CheckAuthSessionEvent extends AuthEvent {}

/// User submitted the login form.
class LoginSubmittedEvent extends AuthEvent {
  LoginSubmittedEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

/// User triggered logout.
class LogoutSubmittedEvent extends AuthEvent {}
