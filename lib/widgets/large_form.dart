import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:basso_hoogerheide/widgets/file_picker_field.dart';
import 'package:basso_hoogerheide/widgets/searchbar.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class LargeForm extends StatefulWidget {
  const LargeForm({
    super.key,
    required this.sections,
    this.sectionTitleStyle,
    this.onSaved,
  });

  final List<LargeFormSection> sections;

  final TextStyle? sectionTitleStyle;

  final void Function(Map<String, dynamic>)? onSaved;

  @override
  State<LargeForm> createState() => _LargeFormState();
}

class _LargeFormState extends State<LargeForm> {
  Map<String, Map<String, dynamic>> _data = {};

  @override
  void initState() {
    super.initState();
    _data = Map.fromEntries(
      widget.sections.map(
        (e) => MapEntry(
          e.key,
          {for (final field in e.fields) field.key: null},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...widget.sections.map(
                (section) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          section.title,
                          style: widget.sectionTitleStyle,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Divider(thickness: 2, height: 20),
                        ),
                      ],
                    ),
                    ListView.separated(
                      itemCount: section.fields.length,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final LargeFormField field = section.fields[index];
                        return _fieldBuilder(context, section, field);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Form.of(context)!.validate()) {
                    widget.onSaved?.call(_data);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _fieldBuilder(
      BuildContext context, LargeFormSection section, LargeFormField field) {
    switch (field.runtimeType) {
      case LargeFormDateField:
        return DatePicker(
          firstDate: (field as LargeFormDateField).firstDate,
          lastDate: field.lastDate,
          labelText: _fieldLabel(field),
          onChanged: (value) =>
              _data[section.key]![field.key] = value?.toIso8601String(),
          validator: (value) => _validator(field.required, value),
        );
      case LargeFormOptionsField:
        return SearchBar(
          options: (field as LargeFormOptionsField).options,
          icon: field.icon,
          label: _fieldLabel(field),
          onChanged: (value) =>
              _data[section.key]![field.key] = value?.toString(),
          validator: (value) => _validator(field.required, value),
          textInputAction: TextInputAction.next,
        );
      case LargeFormDocumentField:
        return FilePickerField(
          hintText: 'Anexar arquivos',
          icon: Icons.attach_file_outlined,
          allowMultiple: true,
          onDocumentAdded: (files) => _data[section.key]![field.key] = files
              .map((e) => {
                    'title': e.path.split('/').last,
                    'path': e.path,
                  })
              .toList(),
        );
      case LargeFormTextField:
      default:
        return TextFormField(
          decoration: InputDecoration(
            labelText: _fieldLabel(field),
            prefixIcon: field.icon != null ? Icon(field.icon) : null,
          ),
          inputFormatters: (field as LargeFormTextField).mask != null
              ? [TextInputMask(mask: field.mask)]
              : null,
          onChanged: (value) =>
              _data[section.key]![field.key] = value.isEmpty ? null : value,
          validator: (value) => _validator(field.required, value),
          textInputAction: TextInputAction.next,
        );
    }
  }

  String? _validator(bool required, Object? value) {
    if (required && (value == null || (value is String && value.isEmpty))) {
      return 'Insira um valor';
    }
    return null;
  }

  String _fieldLabel(LargeFormField field) =>
      "${field.required ? '* ' : ''}${field.title}";
}

class LargeFormSection {
  const LargeFormSection({
    required this.key,
    required this.title,
    required this.fields,
  });

  final String key;

  final String title;

  final List<LargeFormField> fields;
}

abstract class LargeFormField {
  const LargeFormField({
    required this.title,
    required this.key,
    this.icon,
    this.required = true,
  });

  final String title;

  final String key;

  final IconData? icon;

  final bool required;
}

class LargeFormTextField extends LargeFormField {
  const LargeFormTextField({
    required super.title,
    required super.key,
    super.icon,
    super.required,
    this.mask,
    this.type = TextInputType.text,
  });

  final Object? mask;

  final TextInputType type;
}

class LargeFormOptionsField extends LargeFormField {
  const LargeFormOptionsField({
    required super.title,
    required super.key,
    required this.options,
    super.icon,
    super.required,
  });

  final List<String> options;
}

class LargeFormDateField extends LargeFormField {
  const LargeFormDateField({
    required super.title,
    required super.key,
    required this.firstDate,
    required this.lastDate,
    super.icon,
    super.required,
  });

  final DateTime firstDate;

  final DateTime lastDate;
}

class LargeFormDocumentField extends LargeFormField {
  const LargeFormDocumentField({
    required super.title,
    required super.key,
    super.required,
    this.multiple = false,
  });

  final bool multiple;
}
