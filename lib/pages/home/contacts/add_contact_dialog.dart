import 'package:basso_hoogerheide/data_objects/contact.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  Contact _contact = const Contact.empty();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: 400,
        padding: const EdgeInsets.only(
          top: 8,
          right: 8,
          bottom: 8,
        ),
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.only(
              top: 12,
              right: 16,
              bottom: 12,
              left: 16,
            ),
            children: [
              Text(
                'Novo Contato',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                '* Nome',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextFormField(
                  onChanged: (value) =>
                      _contact = _contact.copyWith(name: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                'Telefone',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextFormField(
                  inputFormatters: [TextInputMask(mask: '(99) 9999-9999')],
                  onChanged: (value) =>
                      _contact = _contact.copyWith(telephone: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                'Celular',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextFormField(
                  inputFormatters: [
                    TextInputMask(mask: ['(99) 9999-9999', '(99) 9 9999-9999']),
                  ],
                  onChanged: (value) =>
                      _contact = _contact.copyWith(celullar: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                'E-mail',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextFormField(
                  onChanged: (value) =>
                      _contact = _contact.copyWith(email: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                'Fax',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextFormField(
                  onChanged: (value) =>
                      _contact = _contact.copyWith(email: value),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Text(
                'Endereço',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextFormField(
                  onChanged: (value) =>
                      _contact = _contact.copyWith(email: value),
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20),
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
                        // TODO: adicionar contato
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
    );
  }
}
