import 'package:basso_hoogerheide/widgets/large_form.dart';
import 'package:flutter/material.dart';

class NewFolderPage extends StatelessWidget {
  const NewFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
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
          LargeForm.fromJson(
            // TODO: usar dados do asset
            json: const {},
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
            // TODO: salvar nova pasta
            onSaved: print,
          ),
        ],
      ),
    );
  }
}
