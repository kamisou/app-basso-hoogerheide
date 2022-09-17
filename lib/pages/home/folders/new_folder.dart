import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/models/repository/folders.dart';
import 'package:basso_hoogerheide/widgets/large_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewFolderPage extends ConsumerWidget {
  const NewFolderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Map<String, dynamic> formData = args['form_data'];
    final bool isPerson = args['folder_type'] == 'person';
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Nova Pasta')),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        children: [
          Row(
            children: [
              Text(
                'Cadastrar Pasta',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                child: Text(
                  formData['new_id'].toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LargeForm(
            sections: [
              LargeFormSection(
                key: 'personal_data',
                title: 'Dados Pessoais',
                fields: [
                  LargeFormTextField(
                    key: 'name',
                    title: isPerson ? 'Nome completo' : 'Razão social',
                    icon: isPerson
                        ? Icons.person_outlined
                        : Icons.apartment_outlined,
                    type: TextInputType.name,
                  ),
                  if (isPerson) ...[
                    const LargeFormTextField(
                      key: 'cpf',
                      title: 'CPF',
                      icon: Icons.numbers_outlined,
                      type: TextInputType.number,
                      mask: '999.999.999-99',
                    ),
                    const LargeFormTextField(
                      key: 'rg',
                      title: 'RG',
                      icon: Icons.fingerprint_outlined,
                      type: TextInputType.number,
                      mask: '99.999.999-9',
                      required: false,
                    ),
                  ] else
                    const LargeFormTextField(
                      key: 'cnpj',
                      title: 'CNPJ',
                      icon: Icons.numbers_outlined,
                      type: TextInputType.number,
                      mask: '99.999.999/9999-99',
                    ),
                ],
              ),
              const LargeFormSection(
                key: 'contact_info',
                title: 'Dados de Contato',
                fields: [
                  LargeFormTextField(
                    key: 'email',
                    title: 'E-mail',
                    icon: Icons.email_outlined,
                    type: TextInputType.emailAddress,
                    required: false,
                  ),
                  LargeFormTextField(
                    key: 'telephone',
                    title: 'Telefone',
                    icon: Icons.phone_outlined,
                    type: TextInputType.phone,
                    mask: '(99) 9999-9999',
                    required: false,
                  ),
                  LargeFormTextField(
                    key: 'cellphone',
                    title: 'Celular',
                    icon: Icons.phone_iphone_outlined,
                    type: TextInputType.phone,
                    mask: ['(99) 9999-9999', '(99) 9 9999-9999'],
                    required: false,
                  ),
                ],
              ),
              LargeFormSection(
                key: 'address_info',
                title: 'Dados de Endereço',
                fields: [
                  const LargeFormTextField(
                    key: 'address',
                    title: 'Endereço',
                    icon: Icons.home_outlined,
                    type: TextInputType.name,
                  ),
                  const LargeFormTextField(
                    key: 'district',
                    title: 'Bairro',
                    icon: Icons.location_city_outlined,
                    type: TextInputType.name,
                  ),
                  const LargeFormTextField(
                    key: 'city',
                    title: 'Cidade',
                    icon: Icons.emoji_transportation,
                    type: TextInputType.name,
                  ),
                  LargeFormOptionsField(
                    key: 'state',
                    title: 'Estado',
                    icon: Icons.map_outlined,
                    options: (formData['states'] as List).cast<String>(),
                  ),
                  const LargeFormTextField(
                    key: 'cep',
                    title: 'CEP',
                    icon: Icons.location_on_outlined,
                    type: TextInputType.number,
                    mask: '99999-999',
                    required: false,
                  ),
                ],
              ),
              LargeFormSection(
                key: 'process_info',
                title: 'Detalhes do Processo',
                fields: [
                  LargeFormOptionsField(
                    key: 'attorney',
                    title: 'Procurador',
                    icon: Icons.person_outlined,
                    options: (formData['attorneys'] as List).cast<String>(),
                  ),
                  LargeFormOptionsField(
                    key: 'nature',
                    title: 'Natureza',
                    icon: Icons.file_copy_outlined,
                    options: (formData['nature'] as List).cast<String>(),
                  ),
                  const LargeFormTextField(
                    key: 'number',
                    title: 'Número do processo',
                    icon: Icons.numbers_outlined,
                    type: TextInputType.number,
                    required: false,
                  ),
                  LargeFormDateField(
                    key: 'protocol_date',
                    title: 'Data de protocolo',
                    icon: Icons.map_outlined,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365 * 2)),
                    lastDate: DateTime.now(),
                    required: false,
                  ),
                  LargeFormOptionsField(
                    key: 'division',
                    title: 'Vara',
                    icon: Icons.gavel_outlined,
                    options: (formData['division'] as List).cast<String>(),
                    required: false,
                  ),
                ],
              ),
            ],
            filePicker: ref.read(filePickerProvider),
            sectionTitleStyle:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
            onSaved: ref.read(foldersRepositoryProvider).addFolder,
          ),
        ],
      ),
    );
  }
}
