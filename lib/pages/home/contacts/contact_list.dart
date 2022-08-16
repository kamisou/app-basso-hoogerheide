import 'package:basso_hoogerheide/data_objects/contact.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contact_tile.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({
    super.key,
    required this.contacts,
  });

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return contacts.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: contacts.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: ContactTile(contact: contacts[index]),
            ),
          )
        : const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: EmptyCard(
              icon: Icons.no_accounts_outlined,
              message: 'Nenhum contato encontrado',
            ),
          );
  }
}
