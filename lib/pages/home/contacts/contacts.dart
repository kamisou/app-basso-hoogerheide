import 'package:basso_hoogerheide/data_objects/contact.dart';
import 'package:basso_hoogerheide/pages/home/contacts/contact_tile.dart';
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
          padding: const EdgeInsets.only(left: 40, right: 40, bottom: 32),
          child: SearchBar(
            hintText: 'Pesquisar contato...',
            // TODO: atualizar lista de contatos
            onChanged: (value) {},
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 40, right: 16),
            itemBuilder: (_, index) => const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: ContactTile(
                contact: Contact(
                  name: 'Augusto Fontes',
                  avatarUrl: 'https://picsum.photos/200',
                  telephone: '(42) 9 9999-9999',
                  celullar: '(42) 9 9860-0427',
                  email: 'email@contato.com.br',
                  fax: '(42) 9999-9999',
                  address: 'Rua Padre Piva - Castro',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: adicionar contato
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Contatos';
}
