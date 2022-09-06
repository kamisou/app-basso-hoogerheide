import 'dart:developer';

import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsRepositoryProvider =
    Provider.autoDispose((ref) => const ContactsRepository());

final contactsFilterProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final contactsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(contactsRepositoryProvider).getContacts(),
);

final filteredContactsProvider = FutureProvider.autoDispose((ref) {
  final String? filter = ref.watch(contactsFilterProvider);
  final Future<List<Contact>> contacts = ref.watch(contactsProvider.future);
  return contacts.then((value) {
    if (filter?.isNotEmpty ?? false) {
      final regex = RegExp(filter!, caseSensitive: false);
      return value.where((e) => e.name.contains(regex)).toList();
    }
    return value;
  });
});

class ContactsRepository {
  const ContactsRepository();

  // TODO: adicionar contato
  Future<void> addContact(NewContact? contact) async => log('addContact');

  // TODO: buscar contatos reais
  Future<List<Contact>> getContacts() async {
    log('getContacts');
    return Future.delayed(
      const Duration(seconds: 3),
      () => [
        const Contact(name: 'José da Silva'),
        const Contact(name: 'Maria Albuquerque'),
        const Contact(name: 'Johnatan Souza'),
        const Contact(name: 'João Marcos'),
      ],
    );
  }
}
