import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:basso_hoogerheide/models/repository/contacts.dart';
import 'package:basso_hoogerheide/pages/home/contacts/add_contact_dialog.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contact_tile.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'contacts_fab',
        child: const Icon(Icons.person_add),
        onPressed: () => showDialog<NewContact>(
          context: context,
          builder: (context) => const AddContactDialog(),
        ).then(ref.read(contactsRepositoryProvider).addContact),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar(
              hintText: 'Pesquisar contato...',
              onChanged: (value) =>
                  ref.read(contactsFilterProvider.notifier).state = value,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: AsyncCollection<Contact>(
              asyncCollection: ref.watch(filteredContactsProvider),
              itemBuilder: (_, item) => ContactTile(contact: item),
              emptyWidget: const EmptyCard(
                icon: Icons.no_accounts_outlined,
                message: 'Nenhum contato encontrado',
              ),
              errorWidget: (_) => const EmptyCard(
                icon: Icons.error,
                message: 'Houve um erro ao buscar os contatos',
              ),
              loadingWidget: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20),
                child: const CircularProgressIndicator(),
              ),
              onRefresh: () async => ref.refresh(contactsProvider),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
