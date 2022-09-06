import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:basso_hoogerheide/models/repository/models.dart';
import 'package:basso_hoogerheide/pages/home/models/model_card.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModelsPage extends ConsumerStatefulWidget {
  const ModelsPage({super.key});

  @override
  ConsumerState<ModelsPage> createState() => _ModelsPageState();
}

class _ModelsPageState extends ConsumerState<ModelsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ref.watch(modelsProvider).when(
          data: (data) => Collection<ModelCategory>(
            // TODO: utilizar dados de modelos
            collection: data,
            itemBuilder: (_, item) => ModelCard(
              modelCategory: item,
              onTapUpload: () => ref
                  .read(modelsRepositoryProvider)
                  .uploadModelFile()
                  .then((upload) {
                if (upload == null) return;
                LoadingSnackbar(
                  contentBuilder: (_) =>
                      _loadingContentBuilder(context, upload),
                  errorBuilder: (_) => _errorContentBuilder(context, upload),
                  finishedBuilder: (_) =>
                      _finishedContentBuilder(context, upload),
                ).show(context, upload);
              }),
              onTapDelete: ref.read(modelsRepositoryProvider).deleteModel,
            ),
            emptyWidget: const EmptyCard(
              icon: Icons.file_download_off_outlined,
              message: 'Nenhum modelo encontrado',
            ),
          ),
          error: (_, __) => const EmptyCard(
            icon: Icons.error,
            message: 'Houve um erro ao buscar os modelos',
          ),
          loading: () => Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(),
          ),
        );
  }

  Widget _loadingContentBuilder(
    BuildContext context,
    FileUploadProgressStream upload,
  ) {
    return RichText(
      text: TextSpan(
        text: 'Fazendo upload de ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: upload.fileName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _errorContentBuilder(
    BuildContext context,
    FileUploadProgressStream upload,
  ) {
    return RichText(
      text: TextSpan(
        text: 'Falha ao fazer upload de ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: upload.fileName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _finishedContentBuilder(
    BuildContext context,
    FileUploadProgressStream upload,
  ) {
    return RichText(
      text: TextSpan(
        text: 'Upload de ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: upload.fileName,
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
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
