import 'package:basso_hoogerheide/controllers/contacts.dart';
import 'package:basso_hoogerheide/data_objects/input/contact.dart';
import 'package:basso_hoogerheide/data_objects/output/contact.dart';
import 'package:basso_hoogerheide/pages/home/contacts/add_contact_dialog.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contact_tile.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  final ContactsController controller = const ContactsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => showDialog<ContactOutput>(
          context: context,
          builder: (context) => const AddContactDialog(),
        ).then(controller.addContact),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar(
              hintText: 'Pesquisar contato...',
              // TODO: atualizar filtro da lista de contatos
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Collection<Contact>(
              // TODO: utilizar dados de contato
              collection: const [],
              itemBuilder: (_, item) => ContactTile(contact: item),
              emptyWidget: const EmptyCard(
                icon: Icons.no_accounts_outlined,
                message: 'Nenhum contato encontrado',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
