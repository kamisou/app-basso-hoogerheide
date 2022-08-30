import 'package:basso_hoogerheide/controllers/models.dart';
import 'package:basso_hoogerheide/data_objects/input/model_category.dart';
import 'package:basso_hoogerheide/pages/home/models/model_card.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';

class PickedModelData {
  const PickedModelData({
    required this.title,
    required this.stream,
  });

  final String title;

  final Stream<double> stream;
}

class ModelsPage extends StatelessWidget {
  const ModelsPage({super.key});

  final ModelsController _controller = const ModelsController();

  @override
  Widget build(BuildContext context) {
    return Collection<ModelCategory>(
      // TODO: utilizar dados de modelos
      collection: const [],
      itemBuilder: (_, item) => ModelCard(
        modelCategory: item,
        onTapUpload: () => _controller
            .pickModelFile()
            .then(_controller.uploadModelFile)
            .then((upload) => _displaySnackbar(context, upload)),
      ),
      emptyWidget: const EmptyCard(
        icon: Icons.file_download_off_outlined,
        message: 'Nenhum modelo encontrado',
      ),
    );
  }

  void _displaySnackbar(BuildContext context, PickedModelData? upload) {
    if (upload == null) return;

    final ScaffoldFeatureController scaffoldController =
        _showLoadingSnackbar(context, upload.title, upload.stream);

    upload.stream.last.then(
      (_) {
        scaffoldController.close();
        _showSuccessSnackbar(context, upload.title);
      },
      onError: (_) {
        scaffoldController.close();
        _showErrorSnackbar(context, upload.title);
      },
    );
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
