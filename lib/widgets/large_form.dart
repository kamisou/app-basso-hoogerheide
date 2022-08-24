import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:flutter/foundation.dart';
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

  final void Function(Map<String,dynamic>)? onSaved;

  @override
  State<LargeForm> createState() => _LargeFormState();
}

class _LargeFormState extends State<LargeForm> {
  late List<FocusNode> _focuses;

  @override
  void initState() {
    super.initState();
    _focuses = widget.sections
        .expand((e) => e.fields.map((_) => FocusNode()))
        .toList();
  }

  @override
  void didUpdateWidget(covariant LargeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.sections, widget.sections)) {
      _focuses = widget.sections
          .expand((e) => e.fields.map((_) => FocusNode()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Form(
      key: widget.key,
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
                        final int focusIndex = ++i;
                        switch (field.runtimeType) {
                          case LargeFormDateField:
                            return DatePicker(
                              focusNode: _focuses[focusIndex - 1],
                              firstDate:
                                  (field as LargeFormDateField).firstDate,
                              lastDate: field.lastDate,
                              labelText: _fieldLabel(field),
                              onChanged: (value) => _focusNext(focusIndex),
                            );
                          case LargeFormDropdownField:
                            return DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: _fieldLabel(field),
                                  prefixIcon: field.icon != null
                                      ? Icon(field.icon)
                                      : null,
                                ),
                                focusNode: _focuses[focusIndex - 1],
                                iconDisabledColor:
                                    Theme.of(context).disabledColor,
                                iconEnabledColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .iconColor,
                                items: (field as LargeFormDropdownField)
                                    .options
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) => _focusNext(focusIndex),
                              ),
                            );
                          case LargeFormTextField:
                          default:
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: _fieldLabel(field),
                                prefixIcon: field.icon != null
                                    ? Icon(field.icon)
                                    : null,
                              ),
                              focusNode: _focuses[focusIndex - 1],
                              onEditingComplete: () => _focusNext(focusIndex),
                            );
                        }
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => widget.onSaved?.call({}),
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _fieldLabel(LargeFormField field) =>
      "${field.required ? '* ' : ''}${field.title}";

  void _focusNext(int index) {
    _focuses[index - 1].unfocus();
    if (index < _focuses.length) {
      _focuses[index].requestFocus();
    }
  }
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
