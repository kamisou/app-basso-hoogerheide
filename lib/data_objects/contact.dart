class Contact {
  const Contact({
    required this.name,
    this.telephone,
    this.celullar,
    this.email,
    this.fax,
    this.address,
  });

  final String name;

  final String? telephone;

  final String? celullar;

  final String? email;

  final String? fax;

  final String? address;

  String get initials {
    final List<String> names = name.split(' ');
    return '${names.first[0]}${names.length > 1 ? names[1][0] : ""}';
  }
}
