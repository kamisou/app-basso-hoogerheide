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

  String get initials {
    final List<String> names = name.split(' ');
    return '${names.first[0]}${names.length > 1 ? names[1][0] : ""}';
  }
}
