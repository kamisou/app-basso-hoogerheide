class ContactInfo {
  const ContactInfo({
    this.email,
    this.telephone,
    this.cellphone,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        telephone = json['telephone'],
        cellphone = json['cellphone'];

  final String? email;

  final String? telephone;

  final String? cellphone;
}
