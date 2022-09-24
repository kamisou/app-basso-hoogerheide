import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddContactDialog extends ConsumerStatefulWidget {
  const AddContactDialog({super.key});

  @override
  ConsumerState<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends ConsumerState<AddContactDialog> {
  final NewContact _contact = NewContact.empty();

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
              builder: (context) {
                return ListView(
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
                        onChanged: _contact.setName,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Insira um nome para o contato.'
                            : null,
                      ),
                    ),
                    Text(
                      'Telefone',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      child: TextFormField(
                        inputFormatters: [
                          TextInputMask(mask: '(99) 9999-9999')
                        ],
                        textInputAction: TextInputAction.next,
                        onChanged: _contact.setTelephone,
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
                        onChanged: _contact.setCellphone,
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
                        onChanged: _contact.setEmail,
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
                        onChanged: _contact.setFax,
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
                        onChanged: _contact.setAddress,
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
                              Navigator.pop(context, _contact);
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
