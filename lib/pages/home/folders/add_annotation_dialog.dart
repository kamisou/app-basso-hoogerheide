import 'package:basso_hoogerheide/widgets/searchbar.dart';
import 'package:flutter/material.dart';

class AddAnnotationDialog extends StatefulWidget {
  const AddAnnotationDialog({super.key});

  @override
  State<AddAnnotationDialog> createState() => _AddAnnotationDialogState();
}

class _AddAnnotationDialogState extends State<AddAnnotationDialog> {
  // TODO: sincronizar com initial value da searchbar
  String? _annotation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nova anotação',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Form(
              child: Builder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Assunto:',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    SearchBar<String>(
                      // TODO: utilizar dados de anotações
                      options: const ['A', 'B', 'C'],
                      // initialValue: 'B',
                      onChanged: (value) => _annotation = value,
                      validator: (value) =>
                          value == null ? 'Selecione uma opção' : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            if (Form.of(context)!.validate()) {
                              // TODO: adicionar anotação
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
