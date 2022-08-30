import 'dart:convert';

import 'package:basso_hoogerheide/data_objects/app_user.dart';
import 'package:basso_hoogerheide/data_objects/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/company_folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/person_folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/process_info.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_card.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';

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
          child: Collection<Folder>(
            // TODO: utilizar dados de pasta
            collection: const [
              PersonFolder(
                id: 1500,
                name: 'Maria da Silva',
                writtenOff: true,
                cpf: '117.666.379-81',
                contactInfo: ContactInfo(),
                addressInfo: AddressInfo(
                  street: 'Rua Cristiano Justus',
                  district: 'Boa Vista',
                  city: 'Ponta Grossa',
                  state: 'Paraná',
                ),
                processInfo: ProcessInfo(
                  nature: 'Trabalhista',
                  color: Color(0xFFA0A0A0),
                  attorney: AppUser(
                    name: 'José Maria',
                    email: 'jose@gmail.com',
                    division: 'Something',
                  ),
                ),
                files: [],
              ),
              CompanyFolder(
                id: 1501,
                name: 'Companhia XYZ',
                writtenOff: false,
                cnpj: '17.324.319/0001-32',
                contactInfo: ContactInfo(),
                addressInfo: AddressInfo(
                  street: 'Rua Cristiano Justus',
                  district: 'Boa Vista',
                  city: 'Ponta Grossa',
                  state: 'Paraná',
                ),
                processInfo: ProcessInfo(
                  nature: 'Trabalhista',
                  color: Color(0xFFA0A0A0),
                  attorney: AppUser(
                    name: 'José Maria',
                    email: 'jose@gmail.com',
                    division: 'Something',
                  ),
                ),
                files: [],
              ),
            ],
            itemBuilder: (_, item) => FolderCard(folder: item),
            emptyWidget: const EmptyCard(
              icon: Icons.folder_off_outlined,
              message: 'Nenhuma pasta encontrada',
            ),
          ),
        ),
      ],
    );
  }

  @override
  void Function(BuildContext)? get fabAction =>
      (context) => DefaultAssetBundle.of(context)
          .loadString('assets/new_folder_form_data.json')
          .then((value) => Navigator.pushNamed(
                context,
                '/newFolder',
                arguments: {
                  // TODO: utilizar id de nova pasta
                  'new_id': 1501,
                  'folder_type': 'person',
                  'new_folder_form_data': json.decode(value),
                },
              ));

  @override
  String get title => 'Clientes';
}
