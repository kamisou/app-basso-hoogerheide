import 'dart:convert';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/models/repository/folders.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/large_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureProvider formDataProvider = FutureProvider(
  (ref) => rootBundle
      .loadString('./assets/new_folder_form_data.json')
      .then((value) => json.decode(value)),
);

class NewFolderPage extends ConsumerWidget {
  const NewFolderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Nova Pasta')),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        children: [
          Row(
            children: [
              Text(
                'Cadastrar Pasta',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                child: Text(
                  args['new_id'].toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ref.watch(formDataProvider).when(
                data: (data) => LargeForm.fromJson(
                  json: data,
                  filePicker: ref.read(filePickerProvider),
                  sectionTitleStyle:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                  fieldPredicate: (field) {
                    switch (field.key) {
                      case 'cpf':
                      case 'rg':
                        return args['folder_type'] == 'person';
                      case 'cnpj':
                        return args['folder_type'] == 'company';
                      default:
                        return true;
                    }
                  },
                  onSaved: ref.read(foldersRepositoryProvider).addFolder,
                ),
                error: (_, __) => const EmptyCard(
                  icon: Icons.error,
                  message: 'Falha ao carregar dados do formulário!',
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
        ],
      ),
    );
  }
}
