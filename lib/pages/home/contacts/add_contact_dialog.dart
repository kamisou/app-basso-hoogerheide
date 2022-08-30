import 'package:basso_hoogerheide/controllers/contacts.dart';
import 'package:basso_hoogerheide/data_objects/output/contact.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  ContactOutput _contactOutput = const ContactOutput.empty();

  final ContactsController _controller = const ContactsController();

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
          child: Form(
            child: Builder(
              builder: (context) => ListView(
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
                      textInputAction: TextInputAction.next,
                      onChanged: (name) =>
                          _contactOutput = _contactOutput.copyWith(name: name),
                      validator: _controller.validateName,
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
                      textInputAction: TextInputAction.next,
                      onChanged: (telephone) => _contactOutput =
                          _contactOutput.copyWith(telephone: telephone),
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
                        TextInputMask(
                          mask: ['(99) 9999-9999', '(99) 9 9999-9999'],
                        ),
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: (cellular) =>
                          _contactOutput.copyWith(cellular: cellular),
                    ),
                  ),
                  Text(
                    'E-mail',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onChanged: (email) =>
                          _contactOutput.copyWith(email: email),
                    ),
                  ),
                  Text(
                    'Fax',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onChanged: (fax) => _contactOutput.copyWith(fax: fax),
                    ),
                  ),
                  Text(
                    'Endereço',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      onChanged: (address) =>
                          _contactOutput.copyWith(address: address),
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
                            Navigator.pop(context, _contactOutput);
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
        ),
      ),
    );
  }
}
