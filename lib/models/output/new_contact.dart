import 'package:basso_hoogerheide/models/input/contact.dart';

class NewContact {
  NewContact.empty()
      : id = null,
        name = null,
        telephone = null,
        cellphone = null,
        email = null,
        fax = null,
        address = null;

  NewContact.fromContact(Contact contact)
      : id = contact.id,
        name = contact.name,
        telephone = contact.telephone,
        cellphone = contact.cellphone,
        email = contact.email,
        fax = contact.fax,
        address = contact.address;

  final int? id;

  String? name;

  String? telephone;

  String? cellphone;

  String? email;

  String? fax;

  String? address;

  void setName(String? value) => name = value;

  void setTelephone(String? value) => telephone = value;

  void setCellphone(String? value) => cellphone = value;

  void setEmail(String? value) => email = value;

  void setFax(String? value) => fax = value;

  void setAddress(String? value) => address = value;

  Map<String, dynamic> toJson() => {
        'nome': name,
        'fone': telephone,
        'cel': cellphone,
        'email': email,
        'fax': fax,
        'address': address,
      };
}
