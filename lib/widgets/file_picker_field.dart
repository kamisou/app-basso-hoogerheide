import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerField extends StatelessWidget {
  const FilePickerField({
    super.key,
    required this.filePicker,
    this.icon,
    this.hintText,
    this.onDocumentAdded,
    this.allowMultiple = false,
  });

  final FilePicker filePicker;

  final bool allowMultiple;

  final IconData? icon;

  final String? hintText;

  final void Function(List<File>)? onDocumentAdded;

  @override
  Widget build(BuildContext context) {
    return FormField<List<File>>(
      builder: _formFieldBuilder,
    );
  }

  Widget _formFieldBuilder(FormFieldState<List<File>> state) {
    return GestureDetector(
      onTap: () => _onTapFormField(state),
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
  }

  void _onTapFormField(FormFieldState<List<File>> state) async {
    final List<File>? files = await filePicker.pickFiles(
      dialogTitle: hintText,
      allowMultiple: allowMultiple,
    );
    if (files != null) {
      onDocumentAdded?.call(files);
    }
    state.didChange(files ?? state.value);
  }
}
