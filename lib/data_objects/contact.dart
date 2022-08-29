class Contact {
  const Contact({
    required this.name,
    this.avatarUrl,
    this.telephone,
    this.celullar,
    this.email,
    this.fax,
    this.address,
  });

  const Contact.empty()
      : name = '',
        avatarUrl = null,
        telephone = null,
        celullar = null,
        email = null,
        fax = null,
        address = null;

  final String name;

  final String? avatarUrl;

  final String? telephone;

  final String? celullar;

  final String? email;

  final String? fax;

  final String? address;

  String get initials {
    final List<String> names = name.split(' ');
    return '${names.first[0]}${names.length > 1 ? names[1][0] : ""}';
  }

  Contact copyWith({
    String? name,
    String? avatarUrl,
    String? telephone,
    String? celullar,
    String? email,
    String? fax,
    String? address,
  }) =>
      Contact(
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        telephone: telephone ?? this.telephone,
        celullar: celullar ?? this.celullar,
        email: email ?? this.email,
        fax: fax ?? this.fax,
        address: address ?? this.address,
      );
}
