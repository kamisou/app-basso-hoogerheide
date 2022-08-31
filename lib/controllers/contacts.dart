import 'package:basso_hoogerheide/data_objects/output/new_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsControllerProvider =
    Provider.autoDispose((ref) => ContactsController());

class ContactsController {
  // TODO: adicionar contato
  Future<void> addContact(NewContact? contact) async {}

  String? validateName(String? value) =>
      (value?.isEmpty ?? true) ? 'Informe um nome para o contato' : null;
}
