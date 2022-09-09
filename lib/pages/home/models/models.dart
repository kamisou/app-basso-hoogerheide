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
    return ref.watch(modelsProvider).when(
          data: (data) => Collection<ModelCategory>(
            collection: data,
            itemBuilder: (_, item) => ModelCard(
              modelCategory: item,
              onTapUpload: _onTapUpload,
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

  Future<void> _onTapUpload() async {
    final List<File>? result = await ref.read(filePickerProvider).pickFiles(
          allowMultiple: false,
          dialogTitle: 'Selecione um arquivo para o modelo',
        );
    if (result == null) return;
    // TOOD: exibir snackbar
    return ref.read(modelsRepositoryProvider).uploadModelFile(result.first);
  }

  @override
  bool get wantKeepAlive => true;
}
