import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:basso_hoogerheide/models/repository/models.dart';
import 'package:basso_hoogerheide/pages/home/models/model_card.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
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
    return AsyncCollection<ModelCategory>(
      asyncCollection: ref.watch(modelsProvider),
      itemBuilder: (_, item) => ModelCard(
        modelCategory: item,
        onTapUpload: _onTapUpload,
        onTapDelete: ref.read(modelsRepositoryProvider).deleteModel,
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
        ref.refresh(modelsProvider);
        return ref.read(modelsProvider.future);
      },
    );
  }

  Future<void> _onTapUpload() async {
    final List<File>? result = await ref.read(filePickerProvider).pickFiles(
          allowMultiple: false,
          dialogTitle: 'Selecione um arquivo para o modelo',
        );
    if (result == null) return;
    // TODO: exibir snackbar
    return ref.read(modelsRepositoryProvider).uploadModelFile(result.first);
  }

  @override
  bool get wantKeepAlive => true;
}
