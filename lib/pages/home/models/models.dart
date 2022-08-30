import 'dart:io';

import 'package:basso_hoogerheide/data_objects/model_category.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/pages/home/models/model_card.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ModelsPage extends StatelessWidget {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Collection<ModelCategory>(
      // TODO: utilizar dados de modelos
      collection: const [
        ModelCategory(title: 'Categoria A'),
      ],
      itemBuilder: (_, item) => ModelCard(
        modelCategory: item,
        onTapUpload: () {
          // TODO: segregar lógica de exibição da lógica de aplicação
          _pickFile().then((file) {
            if (file == null) return;

            final String fileTitle = file.path.split('/').last;
            final Stream<double> uploadStream =
                MockUploader().upload(file).asBroadcastStream();

            final ScaffoldFeatureController scaffoldController =
                _showLoadingSnackbar(context, fileTitle, uploadStream);

            uploadStream.last.then(
              (_) {
                scaffoldController.close();
                _showSuccessSnackbar(context, fileTitle);
              },
              onError: (error) {
                scaffoldController.close();
                _showErrorSnackbar(context, fileTitle);
              },
            );
          });
        },
      ),
      emptyWidget: const EmptyCard(
        icon: Icons.file_download_off_outlined,
        message: 'Nenhum modelo encontrado',
      ),
    );
  }

  @override
  void Function(BuildContext)? get fabAction => null;

  @override
  String get title => 'Modelos';

  Future<File?> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecione um arquivo:',
      withReadStream: true,
    );
    if (result == null) return null;
    return File(result.files.first.path!);
  }

  ScaffoldFeatureController _showLoadingSnackbar(
    BuildContext context,
    String fileTitle,
    Stream<double> uploaded,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        content: StreamBuilder<double>(
          stream: uploaded,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'Fazendo upload de ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: fileTitle,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(4),
                    ),
                  ),
                  child: LinearProgressIndicator(value: snapshot.data),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String fileTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Fechar',
          onPressed: () {},
        ),
        content: RichText(
          text: TextSpan(
            text: 'Falha ao fazer upload de ',
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(
                text: fileTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String fileTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Fechar',
          onPressed: () {},
        ),
        content: RichText(
          text: TextSpan(
            text: 'Upload de ',
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(
                text: fileTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                text: ' finalizado',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
