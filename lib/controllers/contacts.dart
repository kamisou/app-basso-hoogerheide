import 'package:basso_hoogerheide/data_objects/output/new_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsControllerProvider = Provider((ref) => ContactsController());

class ContactsController {
  // TODO: adicionar contato
  Future<void> addContact(NewContact? contact) async {}
}
