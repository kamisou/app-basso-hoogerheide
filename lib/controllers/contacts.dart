import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:basso_hoogerheide/repositories/contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsControllerProvider = Provider.autoDispose(ContactsController.new);

class ContactsController {
  const ContactsController(this.ref);

  final Ref ref;

  Future<void> addContact(NewContact? contact) async {
    if (contact == null) return;
    return ref
        .read(restClientProvider)
        .post('/contacts/add', body: contact.toJson())
        .then((_) => ref.refresh(filteredContactsProvider));
  }

  Future<void> editContact(NewContact contact) => ref
      .read(restClientProvider)
      .put('/contacts/edit', body: contact.toJson())
      .then((_) => ref.refresh(filteredContactsProvider));

  Future<void> deleteContact(Contact contact) =>
      ref.read(restClientProvider).delete(
        '/contacts/delete',
        body: {'id': contact.id},
      ).then((_) => ref.refresh(filteredContactsProvider));
}
