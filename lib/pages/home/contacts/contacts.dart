import 'package:basso_hoogerheide/pages/home/contacts/contact_list.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
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
        const Expanded(child: ContactList(contacts: [])),
      ],
    );
  }

  @override
  // TODO: adicionar contato
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Contatos';
}
