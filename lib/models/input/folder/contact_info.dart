class ContactInfo {
  ContactInfo.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        telephone = json['telephone'],
        cellphone = json['cellphone'];

  final String? email;

  final String? telephone;

  final String? cellphone;
}
