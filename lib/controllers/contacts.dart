import 'package:basso_hoogerheide/data_objects/output/contact.dart';

class ContactsController {
  const ContactsController();

  Future<void> addContact(ContactOutput? contact) async {
    if (contact == null) return;
  }

  String? validateName(String? name) {
    if (name?.isEmpty ?? true) {
      return 'Insira um nome';
    }
    return null;
  }
}
