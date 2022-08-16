class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.division,
    this.avatarUrl,
  });

  final String name;

  final String email;

  final String division;

  final String? avatarUrl;
}
