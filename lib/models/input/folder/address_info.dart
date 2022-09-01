class AddressInfo {
  const AddressInfo({
    required this.street,
    required this.district,
    required this.city,
    required this.state,
    this.cep,
  });

  final String street;

  final String district;

  final String city;

  final String state;

  final String? cep;
}
