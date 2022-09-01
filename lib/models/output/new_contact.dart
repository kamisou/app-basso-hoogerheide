class NewContact {
  NewContact.empty()
      : name = null,
        telephone = null,
        cellphone = null,
        email = null,
        fax = null,
        address = null;

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
}
