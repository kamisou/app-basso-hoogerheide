import 'package:flutter/material.dart';

class AddAnnotationDialog extends StatefulWidget {
  const AddAnnotationDialog({super.key});

  @override
  State<AddAnnotationDialog> createState() => _AddAnnotationDialogState();
}

class _AddAnnotationDialogState extends State<AddAnnotationDialog> {
  final TextEditingController _controller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

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
              key: _formKey,
              child: Builder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Anotação'),
                      maxLines: 2,
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
                          onTap: _onTapSave,
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

  void _onTapSave() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _controller.text);
    }
  }
}
