import 'package:flutter_riverpod/flutter_riverpod.dart';

final newContactProvider =
    StateNotifierProvider<NewContactNotifier, NewContact>(
        (ref) => NewContactNotifier());

class NewContactNotifier extends StateNotifier<NewContact> {
  NewContactNotifier() : super(const NewContact.empty());

  void setName(String? value) => state = state.copyWith(name: value);

  void setTelephone(String? value) => state = state.copyWith(telephone: value);

  void setCellphone(String? value) => state = state.copyWith(cellphone: value);

  void setEmail(String? value) => state = state.copyWith(email: value);

  void setFax(String? value) => state = state.copyWith(fax: value);

  void setAddress(String? value) => state = state.copyWith(address: value);

  String? validateName(String? name) =>
      (name?.isEmpty ?? true) ? 'Insira um nome para o evento' : null;
}

class NewContact {
  const NewContact({
    required this.name,
    required this.telephone,
    required this.cellphone,
    required this.email,
    required this.fax,
    required this.address,
  });

  const NewContact.empty()
      : name = null,
        telephone = null,
        cellphone = null,
        email = null,
        fax = null,
        address = null;

  final String? name;

  final String? telephone;

  final String? cellphone;

  final String? email;

  final String? fax;

  final String? address;

  NewContact copyWith({
    String? name,
    String? telephone,
    String? cellphone,
    String? email,
    String? fax,
    String? address,
  }) =>
      NewContact(
        name: name ?? this.name,
        telephone: telephone ?? this.telephone,
        cellphone: cellphone ?? this.cellphone,
        email: email ?? this.email,
        fax: fax ?? this.fax,
        address: address ?? this.address,
      );
}
