class AddressInfo {
  const AddressInfo({
    required this.street,
    required this.district,
    required this.city,
    required this.state,
    this.cep,
  });

  AddressInfo.fromJson(Map<String, dynamic> json)
      : street = json['street'],
        district = json['district'],
        city = json['city'],
        state = json['state'],
        cep = json['cep'];

  final String street;

  final String district;

  final String city;

  final String state;

  final String? cep;
}
