import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsRepositoryProvider = Provider.autoDispose(ContactsRepository.new);

final contactsFilterProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final contactsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(contactsRepositoryProvider).getContacts(),
);

final filteredContactsProvider =
    Provider.autoDispose<AsyncValue<List<Contact>>>((ref) {
  final String? filter = ref.watch(contactsFilterProvider);
  final AsyncValue<List<Contact>> contacts = ref.watch(contactsProvider);
  return contacts.when(
    data: (data) {
      if (filter?.isNotEmpty ?? false) {
        final regex = RegExp(filter!, caseSensitive: false);
        return AsyncData(data.where((e) => e.name.contains(regex)).toList());
      }
      return AsyncData(data);
    },
    error: (error, stackTrace) => AsyncError(error, stackTrace: stackTrace),
    loading: () => const AsyncLoading(),
  );
});

class ContactsRepository {
  const ContactsRepository(this.ref);

  final Ref ref;

  Future<void> addContact(NewContact? contact) async {
    if (contact == null) return;
    return ref
        .read(restClientProvider)
        .post('/contacts/add', body: contact.toJson())
        .then((_) => ref.refresh(contactsRepositoryProvider));
  }

  Future<List<Contact>> getContacts() => ref
      .read(restClientProvider)
      .get('/contacts')
      .then((value) => (value['contacts'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Contact.fromJson)
          .toList());
}
