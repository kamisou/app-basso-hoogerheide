import 'package:basso_hoogerheide/widgets/large_form.dart';
import 'package:flutter/material.dart';

class NewFolderPage extends StatelessWidget {
  const NewFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
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
                  args['new_id'].toString(),
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
                title: 'Dados Pessoais',
                key: 'personal_data',
                fields: [
                  const LargeFormTextField(
                    title: 'Nome completo',
                    key: 'name',
                    icon: Icons.person_outlined,
                    type: TextInputType.name,
                  ),
                  if (args['folder_type'] == 'person')
                    const LargeFormTextField(
                      title: 'CPF',
                      key: 'cpf',
                      icon: Icons.numbers_outlined,
                      mask: '999.999.999-99',
                      type: TextInputType.number,
                    )
                  else
                    const LargeFormTextField(
                      title: 'CNPJ',
                      key: 'cnpj',
                      icon: Icons.numbers_outlined,
                      mask: '99.999.999/9999-99',
                      type: TextInputType.number,
                    ),
                  if (args['folder_type'] == 'person')
                    const LargeFormTextField(
                      title: 'RG',
                      key: 'rg',
                      icon: Icons.fingerprint_outlined,
                      mask: '99.999.999-99',
                      type: TextInputType.number,
                      required: false,
                    ),
                ],
              ),
              const LargeFormSection(
                title: 'Dados de Contato',
                key: 'contact_info',
                fields: [
                  LargeFormTextField(
                    title: 'E-mail',
                    key: 'email',
                    icon: Icons.email_outlined,
                    type: TextInputType.emailAddress,
                    required: false,
                  ),
                  LargeFormTextField(
                    title: 'Telefone',
                    key: 'phone',
                    icon: Icons.phone_outlined,
                    type: TextInputType.phone,
                    required: false,
                  ),
                  LargeFormTextField(
                    title: 'Celular',
                    key: 'cellphone',
                    icon: Icons.phone_iphone_outlined,
                    type: TextInputType.phone,
                    required: false,
                  ),
                ],
              ),
              const LargeFormSection(
                title: 'Endereço',
                key: 'address_info',
                fields: [
                  LargeFormTextField(
                    title: 'Endereço',
                    key: 'address',
                    icon: Icons.home_outlined,
                    type: TextInputType.name,
                  ),
                  LargeFormTextField(
                    title: 'Bairro',
                    key: 'district',
                    icon: Icons.location_city_outlined,
                    type: TextInputType.name,
                  ),
                  LargeFormTextField(
                    title: 'Cidade',
                    key: 'city',
                    icon: Icons.emoji_transportation,
                    type: TextInputType.name,
                  ),
                  LargeFormDropdownField(
                    title: 'Estado',
                    key: 'state',
                    icon: Icons.map_outlined,
                    options: ['PR', 'pA'],
                  ),
                  LargeFormTextField(
                    title: 'CEP',
                    key: 'cep',
                    icon: Icons.location_on_outlined,
                    type: TextInputType.number,
                    required: false,
                  ),
                ],
              ),
              LargeFormSection(
                title: 'Detalhes do Processo',
                key: 'process_info',
                fields: [
                  const LargeFormDropdownField(
                    title: 'Procurador',
                    key: 'attorney',
                    icon: Icons.person_outlined,
                    options: [],
                  ),
                  const LargeFormDropdownField(
                    title: 'Natureza',
                    key: 'nature',
                    icon: Icons.file_copy_outlined,
                    options: [],
                  ),
                  const LargeFormTextField(
                    title: 'Número do processo',
                    key: 'number',
                    type: TextInputType.number,
                    icon: Icons.numbers_outlined,
                    required: false,
                  ),
                  LargeFormDateField(
                    title: 'Data do protocolo',
                    key: 'protocol_date',
                    icon: Icons.numbers_outlined,
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2023),
                    required: false,
                  ),
                  const LargeFormDropdownField(
                    title: 'Comarca',
                    key: 'district',
                    icon: Icons.map_outlined,
                    options: [],
                  ),
                  const LargeFormDropdownField(
                    title: 'Vara',
                    key: 'division',
                    icon: Icons.gavel_outlined,
                    options: [],
                  ),
                ],
              ),
              const LargeFormSection(
                title: 'Documentos do Processo',
                key: 'documents',
                fields: [],
              ),
            ],
            sectionTitleStyle:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
            // TODO: salvar nova pasta
            onSaved: (value) {},
          ),
        ],
      ),
    );
  }
}
