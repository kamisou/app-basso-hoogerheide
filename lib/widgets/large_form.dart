import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class LargeForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...sections.map(
                (section) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          section.title,
                          style: sectionTitleStyle,
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
                        return _fieldBuilder(context, field);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Form.of(context)!.validate()) {
                    onSaved?.call({});
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

  Widget _fieldBuilder(BuildContext context, LargeFormField field) {
    switch (field.runtimeType) {
      case LargeFormDateField:
        return DatePicker(
          firstDate: (field as LargeFormDateField).firstDate,
          lastDate: field.lastDate,
          labelText: _fieldLabel(field),
          validator: (value) => _validator(field.required, value),
        );
      case LargeFormDropdownField:
        return DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: _fieldLabel(field),
              prefixIcon: field.icon != null ? Icon(field.icon) : null,
            ),
            iconDisabledColor: Theme.of(context).disabledColor,
            iconEnabledColor: Theme.of(context).inputDecorationTheme.iconColor,
            items: (field as LargeFormDropdownField)
                .options
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {},
            validator: (value) => _validator(field.required, value),
          ),
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

class LargeFormDropdownField extends LargeFormField {
  const LargeFormDropdownField({
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
