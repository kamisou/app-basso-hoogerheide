import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/data_objects/folder/company_folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/person_folder.dart';
import 'package:flutter/material.dart';

class FolderCard extends StatefulWidget {
  const FolderCard({
    super.key,
    required this.folder,
  });

  final Folder folder;

  @override
  State<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final curveAndDuration =
        Theme.of(context).extension<CurveAndDurationExtension>()!;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: 4,
                    child: ColoredBox(
                      color: Color(widget.folder.processInfo.color),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardHeader(context),
                          Column(
                            children: [
                              AnimatedSwitcher(
                                duration: curveAndDuration.duration,
                                reverseDuration: curveAndDuration.duration,
                                switchInCurve: curveAndDuration.curve,
                                switchOutCurve: curveAndDuration.curve,
                                child: _expanded
                                    ? _cardBody(context)
                                    : const SizedBox(
                                        height: 0,
                                        width: double.infinity,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (widget.folder.writtenOff && !_expanded)
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color:
                  Theme.of(context).extension<SuccessThemeExtension>()?.success,
            ),
            margin: const EdgeInsets.only(top: 8, right: 8),
            height: 6,
            width: 6,
          ),
      ],
    );
  }

  Widget _cardHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.folder.id} - ${widget.folder.name}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  widget.folder is PersonFolder
                      ? (widget.folder as PersonFolder).cpf
                      : (widget.folder as CompanyFolder).cnpj,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
          ),
        ),
        Icon(
          widget.folder is PersonFolder
              ? Icons.person_outline
              : Icons.apartment,
          color: Theme.of(context).disabledColor,
          size: 36,
        ),
      ],
    );
  }

  Widget _cardBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.folder.writtenOff)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  Theme.of(context).extension<SuccessThemeExtension>()?.success,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 1,
            ),
            child: Text(
              'Baixado',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
      ],
    );
  }
}
