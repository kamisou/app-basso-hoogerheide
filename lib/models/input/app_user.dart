class AppUser {
  AppUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        division = json['division'],
        avatarUrl = json['avatar_url'];

  final String name;

  final String email;

  final String division;

  final String? avatarUrl;

  String get initials {
    final List<String> names = name.split(' ');
    return '${names.first[0]}${names.length > 1 ? names[1][0] : ""}';
  }
}
