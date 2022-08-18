import 'dart:io';

import 'package:basso_hoogerheide/data_objects/app_user.dart';
import 'package:basso_hoogerheide/data_objects/folder/address_info.dart';
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
            collection: [
              PersonFolder(
                id: 1500,
                name: 'Maria da Silva',
                writtenOff: true,
                cpf: '117.666.379-81',
                rg: '14.338.593-0',
                contactInfo: const ContactInfo(
                  cellular: '(42) 9 9860-0427',
                  email: 'kamisou@outlook.com',
                ),
                addressInfo: const AddressInfo(
                  street: 'Rua Cristiano Justos Júnior',
                  district: 'Boa Vista',
                  city: 'Ponta Grossa',
                  state: 'Paraná',
                ),
                processInfo: const ProcessInfo(
                  nature: 'Trabalhista',
                  color: 0xFFFF00F3,
                  attorney: AppUser(
                    name: 'João Marcos',
                    email: 'kamisou@outlook.com',
                    division: 'Admin',
                  ),
                ),
                files: [],
                annotations: [],
                timestamp: DateTime.now(),
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
  // TODO: adicionar pasta
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Clientes';
}
