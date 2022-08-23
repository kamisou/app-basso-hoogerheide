import 'package:basso_hoogerheide/data_objects/folder/annotation.dart';
import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/widgets/avatar_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnotationsPage extends StatelessWidget {
  const AnnotationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final folder = ModalRoute.of(context)?.settings.arguments as Folder;
    return Scaffold(
      appBar: AppBar(title: Text('${folder.id} - ${folder.name}')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
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
        ),
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
                          initials: 'JM',
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
                                    .format(annotation.timestamp),
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
