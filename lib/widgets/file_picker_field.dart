import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerField extends StatelessWidget {
  const FilePickerField({
    super.key,
    this.icon,
    this.hintText,
    this.onDocumentAdded,
    this.allowMultiple,
  });

  final bool? allowMultiple;

  final IconData? icon;

  final String? hintText;

  final void Function(List<File>)? onDocumentAdded;

  @override
  Widget build(BuildContext context) {
    return FormField<List<File>>(
      builder: (state) {
        return GestureDetector(
          onTap: () async {
            final List<File>? files = await FilePicker().pickFiles(
              dialogTitle: hintText,
              allowMultiple: allowMultiple,
            );
            if (files != null) {
              onDocumentAdded?.call(files);
            }
            state.didChange(files ?? state.value);
          },
          child: TextFormField(
            decoration: InputDecoration(
              hintText: state.value == null
                  ? hintText
                  : state.value!.map((e) => e.path.split('/').last).join('\n'),
              hintMaxLines: state.value?.length,
              prefixIcon: icon != null ? Icon(icon) : null,
            ),
            enabled: false,
          ),
        );
      },
    );
  }
}
