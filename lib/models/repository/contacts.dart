import 'dart:developer';

import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsRepositoryProvider =
    Provider.autoDispose((ref) => const ContactsRepository());

class ContactsRepository {
  const ContactsRepository();

  // TODO: adicionar contato
  Future<void> addContact(NewContact? contact) async => log('addContact');
}
