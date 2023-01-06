import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';

class FolderCardHeader extends StatelessWidget {
  const FolderCardHeader({
    super.key,
    required this.folder,
  });

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: folder.processInfo.color.withOpacity(1),
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.only(
              bottom: 12,
              top: 12,
              left: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${folder.id} - ${folder.name}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                KeyValueText(
                  keyString: 'CPF',
                  valueString: folder.cpf,
                ),
                if (folder.rg?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'RG',
                    valueString: folder.rg!,
                  ),
              ],
            ),
          ),
        ),
        Icon(
          Icons.person_outline,
          color: Theme.of(context).disabledColor,
          size: 36,
        ),
      ],
    );
  }
}
