import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/models/repository/folders.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/large_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewFolderPage extends ConsumerWidget {
  const NewFolderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Nova Pasta')),
      body: ref.watch(folderFormData).when(
            data: (data) => ListView(
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
                  ],
                ),
                const SizedBox(height: 24),
                LargeForm(
                  json: data,
                  filePicker: ref.read(filePickerProvider),
                  sectionTitleStyle:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                  onSaved: ref.read(foldersRepositoryProvider).addFolder,
                ),
              ],
            ),
            error: (_, __) => const Padding(
              padding: EdgeInsets.all(20),
              child: EmptyCard(
                icon: Icons.error_outline,
                message: 'Não foi possível buscar dados para nova pasta.',
              ),
            ),
            loading: () => Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(),
            ),
          ),
    );
  }
}
