import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:basso_hoogerheide/widgets/file_picker_field.dart';
import 'package:basso_hoogerheide/widgets/searchbar.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class LargeForm extends StatefulWidget {
  const LargeForm({
    super.key,
    required this.json,
    required this.filePicker,
    this.sectionTitleStyle,
    this.onSaved,
  });

  final Map<String, dynamic> json;

  final FilePicker filePicker;

  final TextStyle? sectionTitleStyle;

  final Future<void> Function(Map<String, dynamic>)? onSaved;

  @override
  State<LargeForm> createState() => _LargeFormState();
}

class _LargeFormState extends State<LargeForm> {
  late List<LargeFormSection> _sections;

  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _parseJson(widget.json);
  }

  void _parseJson(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> sections =
        (json['sections'] as List? ?? []).cast<Map<String, dynamic>>();
    _data = Map.fromEntries(
      sections.expand(
        (section) => (section['fields'] as List? ?? []).map(
          (field) => MapEntry(field['key'], null),
        ),
      ),
    );
    _sections = sections.map((section) {
      final List<Map<String, dynamic>> fields =
          (section['fields'] as List? ?? []).cast<Map<String, dynamic>>();
      return LargeFormSection(
        key: section['key'],
        title: section['title'],
        fields: fields.map((field) {
          final IconData icon = IconData(
            int.parse(field['icon'], radix: 16),
            fontFamily: 'MaterialIcons',
          );
          final bool required = field['required'] ?? true;
          switch (field['type']) {
            case 'options':
              return LargeFormOptionsField(
                key: field['key'],
                title: field['title'],
                icon: icon,
                initialValue: field['initial_value'],
                required: required,
                options: (field['options'] as List? ?? []).cast<String>(),
              );
            case 'date':
              return LargeFormDateField(
                key: field['key'],
                title: field['title'],
                icon: icon,
                initialValue:
                    ((field['initial_value'] as String?)?.isNotEmpty ?? false)
                        ? DateTime.parse(field['initial_value'])
                        : null,
                required: required,
                firstDate: DateTime.parse(field['first_date']),
                lastDate: DateTime.parse(field['last_date']),
              );
            case 'file':
              return LargeFormFileField(
                key: field['key'],
                title: field['title'],
                required: field['required'],
                multiple: field['multiple'] ?? false,
              );
          }
          return LargeFormTextField(
            key: field['key'],
            title: field['title'],
            icon: icon,
            initialValue: field['initial_value'],
            mask: field['mask'] is List
                ? (field['mask'] as List? ?? []).cast<String>()
                : field['mask'],
            required: required,
            type: TextInputType.values.firstWhere(
              (e) => e.toJson()['name'] == 'TextInputType.${field['type']}',
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._sections.map(
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
                      itemBuilder: (_, index) =>
                          _fieldBuilder(section, section.fields[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    ),
                  ],
                ),
              ),
              ElevatedAsyncButton(
                onPressed: () async {
                  if (Form.of(context)!.validate()) {
                    return widget.onSaved?.call(_data);
                  }
                },
                loadingChild: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _fieldBuilder(LargeFormSection section, LargeFormField field) {
    switch (field.runtimeType) {
      case LargeFormDateField:
        return DatePicker(
          firstDate: (field as LargeFormDateField).firstDate,
          initialDate: field.initialValue,
          lastDate: field.lastDate,
          labelText: _fieldLabel(field),
          onChanged: (value) => _data[field.key] = value?.toIso8601String(),
          validator: (value) => _validator(field.required, value),
        );
      case LargeFormOptionsField:
        return SearchBar(
          options: (field as LargeFormOptionsField).options,
          icon: field.icon,
          initialValue: field.initialValue,
          label: _fieldLabel(field),
          onChanged: (value) => _data[field.key] = value?.toString(),
          validator: (value) => _validator(field.required, value),
          textInputAction: TextInputAction.next,
        );
      case LargeFormFileField:
        return FilePickerField(
          filePicker: widget.filePicker,
          hintText: 'Anexar arquivos',
          icon: Icons.attach_file_outlined,
          allowMultiple: true,
          onDocumentAdded: (files) => _data[field.key] = files
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
          initialValue: (field as LargeFormTextField).initialValue,
          inputFormatters:
              field.mask != null ? [TextInputMask(mask: field.mask)] : null,
          onChanged: (value) => _data[field.key] = value.isEmpty ? null : value,
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
    required this.key,
    required this.title,
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
    required super.key,
    required super.title,
    super.icon,
    super.required,
    this.initialValue,
    this.mask,
    this.type = TextInputType.text,
  });

  final String? initialValue;

  final Object? mask;

  final TextInputType type;
}

class LargeFormOptionsField extends LargeFormField {
  const LargeFormOptionsField({
    required super.key,
    required super.title,
    required this.options,
    super.icon,
    super.required,
    this.initialValue,
  });

  final String? initialValue;

  final List<String> options;
}

class LargeFormDateField extends LargeFormField {
  const LargeFormDateField({
    required super.key,
    required super.title,
    required this.firstDate,
    required this.lastDate,
    super.icon,
    super.required,
    this.initialValue,
  });

  final DateTime? initialValue;

  final DateTime firstDate;

  final DateTime lastDate;
}

class LargeFormFileField extends LargeFormField {
  const LargeFormFileField({
    required super.key,
    required super.title,
    super.required,
    this.multiple = false,
  });

  final bool multiple;
}
