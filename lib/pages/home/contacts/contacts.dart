import 'package:basso_hoogerheide/data_objects/contact.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contact_tile.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class ContactsPage extends HomePageBody {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            hintText: 'Pesquisar contato...',
            // TODO: atualizar lista de contatos
            onChanged: (value) {},
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Collection<Contact>(
            collection: const [],
            itemBuilder: (_, item) => ContactTile(contact: item),
            emptyWidget: const EmptyCard(
              icon: Icons.no_accounts_outlined,
              message: 'Nenhum contato encontrado',
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: adicionar contato
  void Function(BuildContext)? get fabAction => (context) {};

  @override
  String get title => 'Contatos';
}
