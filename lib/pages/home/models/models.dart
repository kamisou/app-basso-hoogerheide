import 'package:basso_hoogerheide/interface/file_picker.dart';
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
    return Column(
      children: [
        AsyncCollection<ModelCategory>(
          asyncCollection: ref.watch(modelCategoriesProvider),
          itemBuilder: (_, category) => ModelCard(
            modelCategory: category,
            onTapUpload: () => _onTapUpload(context, category),
            onTapDelete: (file) => ref
                .read(modelsRepositoryProvider)
                .deleteModel(category.id, file.id),
          ),
          errorWidget: (_) => const EmptyCard(
            icon: Icons.error,
            message: 'Houve um erro ao buscar os modelos',
          ),
          emptyWidget: const EmptyCard(
            icon: Icons.file_download_off_outlined,
            message: 'Nenhum modelo encontrado',
          ),
          loadingWidget: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(),
          ),
          onRefresh: () {
            ref.refresh(modelCategoriesProvider);
            return ref.read(modelCategoriesProvider.future);
          },
        ),
      ],
    );
  }

  void _onTapUpload(BuildContext context, ModelCategory category) {
    ref
        .read(filePickerProvider)
        .pickFiles(
          allowMultiple: false,
          dialogTitle: 'Selecione um arquivo para o modelo',
        )
        .then((value) {
      if (value == null) return;

      final String fileName = value.first.path.split('/').last;

      LoadingSnackbar(
        contentBuilder: (context) => Text(
          'Fazendo upload do modelo $fileName',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        errorBuilder: (context, _) => Text(
          'Houve um erro ao fazer o upload de $fileName!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ).show(
        context,
        ref
            .read(modelsRepositoryProvider)
            .uploadModelFile(category.id, value.first),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
