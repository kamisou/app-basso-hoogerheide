import 'package:basso_hoogerheide/data_objects/app_user.dart';
import 'package:basso_hoogerheide/data_objects/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/file.dart';
import 'package:basso_hoogerheide/data_objects/folder/person_folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/process_info.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_card.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';

class FoldersPage extends HomePageBody {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            hintText: 'N° da pasta, cliente, procurador, CPF...',
            // TODO: atualizar lista de pastas
            onChanged: (value) {},
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FolderCard(
                folder: PersonFolder(
                  id: 1523,
                  name: 'Maria da Silva',
                  writtenOff: true,
                  cpf: '333.333.333-33',
                  contactInfo: const ContactInfo(
                    telephone: '(42) 9 9999-9999',
                  ),
                  addressInfo: const AddressInfo(
                    street: 'Avenida dos Pinheiros',
                    district: 'Pilatos',
                    city: 'Carambeí',
                    state: 'PR',
                  ),
                  processInfo: const ProcessInfo(
                    nature: 'Trabalhista',
                    color: 0xFFF39C12,
                    attorney: AppUser(
                      name: 'João Marcos',
                      email: 'kamisou@outlook.com',
                      division: 'Admin',
                    ),
                  ),
                  files: [
                    const FolderFile(
                      title: 'COMPROVANTE DE RESIDÊNCIA.pdf',
                      url: 'http://www.bassoadvogados.adv.br/painel/clientes/'
                          'download/1550/COMPROVANTE%20DE%20RESIDENCIA%20GENI%20(2).pdf',
                    ),
                    const FolderFile(
                      title: 'CONTRATO DE HONORARIOS GENI.pdf',
                      url: 'http://www.bassoadvogados.adv.br/painel/clientes/'
                          'download/1550/CONTRATO%20DE%20HONORARIOS%20GENI.pdf',
                    ),
                  ],
                  annotations: [],
                  timestamp: DateTime.now(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: adicionar pasta
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Clientes';
}
