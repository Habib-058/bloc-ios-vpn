class AppUser {
  final int id;
  final String googleId;
  final String? username;
  final String? password;
  final String? email;
  final bool? isSubscriptionStatus;

  AppUser({
    required this.id,
    required this.googleId,
    this.username,
    this.password,
    this.email,
    this.isSubscriptionStatus,
  });
}