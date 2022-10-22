import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/folder/annotation.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/repository/folders.dart';
import 'package:basso_hoogerheide/pages/home/folders/add_annotation_dialog.dart';
import 'package:basso_hoogerheide/widgets/avatar_circle.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AnnotationsPage extends ConsumerWidget {
  const AnnotationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;
    return Scaffold(
      appBar: AppBar(title: Text('${folder.id} - ${folder.name}')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note_add),
        onPressed: () => showDialog<String?>(
          context: context,
          builder: (context) => const AddAnnotationDialog(),
        ).then(
          (annotation) => ref
              .read(foldersRepositoryProvider)
              .addAnnotation(folder.id, annotation)
              .then(
            (_) {
              ref.refresh(foldersRepositoryProvider);
              Navigator.pop(context);
            },
            onError: (e) => ErrorSnackbar(
              context: context,
              error: e,
            ).on<RestException>(
              content: (error) => ErrorContent(
                message: error.serverMessage,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: folder.annotations.isNotEmpty
            ? SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        color: Theme.of(context).disabledColor,
                        margin: const EdgeInsets.only(left: 5),
                        width: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: folder.annotations
                              .map((e) => _cardBuilder(context, e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, Annotation annotation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).disabledColor,
            ),
            height: 12,
            width: 12,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      annotation.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        AvatarCircle(
                          initials: annotation.author.initials,
                          avatarUrl: annotation.author.avatarUrl,
                          backgroundColor: Theme.of(context).disabledColor,
                          radius: 24,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Edição por ${annotation.author.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(annotation.createdAt),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
