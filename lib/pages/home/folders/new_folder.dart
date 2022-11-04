import 'package:basso_hoogerheide/controllers/folders.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/repositories/folders.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/large_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewFolderPage extends ConsumerWidget {
  const NewFolderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? folderId = ModalRoute.of(context)!.settings.arguments as int?;
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Nova Pasta')),
      body: ref.watch(folderFormData(folderId)).when(
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
                  sectionTitleStyle:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                  onSaved: (data) => ref
                      .read(foldersControllerProvider)
                      .addFolder(data)
                      .then((_) => Navigator.pop(context),
                          onError: (e) =>
                              ErrorSnackbar(context: context, error: e)
                                  .on<RestException>(
                                content: (error) =>
                                    ErrorContent(message: error.serverMessage),
                              )),
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
