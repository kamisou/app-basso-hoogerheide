class ContactOutput {
  const ContactOutput({
    required this.name,
    required this.telephone,
    required this.cellular,
    required this.email,
    required this.fax,
    required this.address,
  });

  const ContactOutput.empty()
      : name = null,
        telephone = null,
        cellular = null,
        email = null,
        fax = null,
        address = null;

  final String? name;

  final String? telephone;

  final String? cellular;

  final String? email;

  final String? fax;

  final String? address;

  ContactOutput copyWith({
    String? name,
    String? telephone,
    String? cellular,
    String? email,
    String? fax,
    String? address,
  }) =>
      ContactOutput(
        name: name ?? this.name,
        telephone: telephone ?? this.telephone,
        cellular: cellular ?? this.cellular,
        email: email ?? this.email,
        fax: fax ?? this.fax,
        address: address ?? this.address,
      );
}
