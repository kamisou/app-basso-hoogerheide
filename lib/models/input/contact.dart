class Contact {
  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        telephone = json['telephone'],
        cellphone = json['cellphone'],
        email = json['email'],
        fax = json['fax'],
        address = json['address'];

  final int id;

  final String name;

  final String? telephone;

  final String? cellphone;

  final String? email;

  final String? fax;

  final String? address;

  String get initials {
    final List<String> names = name.split(' ');
    return '${names.first[0]}${names.length > 1 ? names[1][0] : ""}';
  }
}
