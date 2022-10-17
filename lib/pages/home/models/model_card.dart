import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModelCard extends StatefulWidget {
  const ModelCard({
    super.key,
    required this.modelCategory,
    this.onTapUpload,
    this.onTapDelete,
  });

  final ModelCategory modelCategory;

  final VoidCallback? onTapUpload;

  final void Function(DownloadableFile)? onTapDelete;

  @override
  State<ModelCard> createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Card(
            shape: const RoundedRectangleBorder(),
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.modelCategory.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Modelos: ${widget.modelCategory.models.length.toString()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ...widget.modelCategory.models.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _document(context, e),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: widget.onTapUpload,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.upload_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Novo Modelo',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _document(BuildContext context, DownloadableFile file) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.filename,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                DateFormat("dd/MM/yyyy' - 'HH:mm").format(file.uploadTimestamp),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: widget.onTapDelete != null
              ? () => widget.onTapDelete!(file)
              : null,
          child: Icon(
            Icons.delete_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
