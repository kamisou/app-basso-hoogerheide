import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsRepositoryProvider = Provider.autoDispose(ContactsRepository.new);

final contactsFilterProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final contactsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(contactsRepositoryProvider).getContacts(),
);

final folderContactsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(contactsRepositoryProvider).getFolderContacts(),
);

final filteredContactsProvider = FutureProvider.autoDispose((ref) async {
  final String? filter = ref.watch(contactsFilterProvider);
  final List<Contact> contacts = await ref.watch(contactsProvider.future);
  if (filter?.isNotEmpty ?? false) {
    final regex = RegExp(filter!, caseSensitive: false);
    return contacts.where((e) => e.name.contains(regex)).toList();
  }
  return contacts;
});

final filteredFolderContactsProvider = FutureProvider.autoDispose((ref) async {
  final String? filter = ref.watch(contactsFilterProvider);
  final List<Contact> contacts = await ref.watch(folderContactsProvider.future);
  if (filter?.isNotEmpty ?? false) {
    final regex = RegExp(filter!, caseSensitive: false);
    return contacts.where((e) => e.name.contains(regex)).toList();
  }
  return contacts;
});

class ContactsRepository {
  const ContactsRepository(this.ref);

  final Ref ref;

  Future<List<Contact>> getContacts() => ref
      .read(restClientProvider)
      .get('/contacts')
      .then((value) => (value['contacts'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Contact.fromJson)
          .toList());

  Future<List<Contact>> getFolderContacts() => ref
      .read(restClientProvider)
      .get('/contacts/folders')
      .then((value) => (value['folder_contacts'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Contact.fromJson)
          .toList());
}
