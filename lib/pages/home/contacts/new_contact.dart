import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/models/output/new_contact.dart';
import 'package:basso_hoogerheide/models/repository/contacts.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewContactPage extends ConsumerStatefulWidget {
  const NewContactPage({super.key});

  @override
  ConsumerState<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends ConsumerState<NewContactPage> {
  late NewContact _contact;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final contact = ModalRoute.of(context)!.settings.arguments as Contact?;
    _contact =
        contact == null ? NewContact.empty() : NewContact.fromContact(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo contato'),
      ),
      body: Form(
        child: Builder(
          builder: (context) {
            return ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '* Nome',
                  ),
                  initialValue: _contact.name,
                  onChanged: _contact.setName,
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'Informe um nome para o contato.'
                      : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                  ),
                  initialValue: _contact.telephone,
                  onChanged: _contact.setTelephone,
                  inputFormatters: [TextInputMask(mask: '(99) 9999-9999')],
                  validator: (value) => (value?.isNotEmpty ?? false)
                      ? !RegExp(r'^\(\d{2}\) \d{4}-\d{4}$').hasMatch(value!)
                          ? 'Informe um número de telefone rápido.'
                          : null
                      : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Celular',
                  ),
                  initialValue: _contact.cellphone,
                  onChanged: _contact.setCellphone,
                  inputFormatters: [
                    TextInputMask(mask: ['(99) 9999-9999', '(99) 9 9999-9999']),
                  ],
                  validator: (value) => (value?.isNotEmpty ?? false)
                      ? !RegExp(r'^\(\d{2}\)( \d:?)? \d{4}-\d{4}$')
                              .hasMatch(value!)
                          ? 'Informe um número de celular válido.'
                          : null
                      : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  initialValue: _contact.email,
                  onChanged: _contact.setEmail,
                  validator: (value) => (value?.isNotEmpty ?? false)
                      ? !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value!)
                          ? 'Informe um endereço de e-mail válido.'
                          : null
                      : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Fax'),
                  initialValue: _contact.fax,
                  onChanged: _contact.setFax,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  initialValue: _contact.address,
                  onChanged: _contact.setAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                ElevatedAsyncButton(
                  onPressed: () => _onSave(context),
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
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (Form.of(context)!.validate()) {
      final ContactsRepository contactsRepository =
          ref.read(contactsRepositoryProvider);

      return (_contact.id == null
              ? contactsRepository.addContact(_contact)
              : contactsRepository.editContact(_contact))
          .then(
        (_) => Navigator.pop(context),
        onError: (e) => ErrorSnackbar(
          context: context,
          error: e,
        ).on<RestException>(
          content: (error) => ErrorContent(message: error.serverMessage),
        ),
      );
    }
  }
}