import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/controllers/folders.dart';
import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/folder/address_info.dart';
import 'package:basso_hoogerheide/models/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/input/folder/process_info.dart';
import 'package:basso_hoogerheide/widgets/folder_card/folder_card_section.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class FolderCardBody extends ConsumerWidget {
  const FolderCardBody({
    super.key,
    required this.folder,
  });

  final Folder folder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AddressInfo address = folder.addressInfo;
    final ContactInfo contact = folder.contactInfo;
    final ProcessInfo process = folder.processInfo;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: folder.processInfo.color.withOpacity(1),
            width: 4,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (folder.writtenOff)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Theme.of(context)
                          .extension<SuccessThemeExtension>()
                          ?.success,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1,
                    ),
                    child: Text(
                      'Baixado',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                const FolderCardSection(
                  icon: Icons.home_outlined,
                  title: 'Endereço',
                ),
                Text(
                  '${address.street} - ${address.district}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${address.city} - ${address.state}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (address.cep?.isNotEmpty ?? false)
                  Text(
                    address.cep!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                const FolderCardSection(
                  icon: Icons.phone_outlined,
                  title: 'Contato',
                ),
                if (contact.email?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'E-mail',
                    valueString: contact.email!,
                  ),
                if (contact.telephone?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'Telefone',
                    valueString: contact.telephone!,
                  ),
                if (contact.cellphone?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'Celular',
                    valueString: contact.cellphone!,
                  ),
                const FolderCardSection(
                  icon: Icons.description_outlined,
                  title: 'Detalhes',
                ),
                KeyValueText(
                  keyString: 'Natureza',
                  valueString: process.nature,
                ),
                if (process.number?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'N° do Processo',
                    valueString: process.number!.toString(),
                  ),
                if (process.county?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'Comarca',
                    valueString: process.county!.toString(),
                  ),
                if (process.division?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'Vara',
                    valueString: process.division!.toString(),
                  ),
                const FolderCardSection(
                  icon: Icons.file_present_outlined,
                  title: 'Arquivos',
                ),
              ],
            ),
          ),
          ...folder.files.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () => launchUrl(
                  Uri.parse('${e.url}?token=${ref.read(authTokenProvider)}'),
                  mode: LaunchMode.externalApplication,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.open_in_new_outlined,
                        color: Theme.of(context).disabledColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () => ref
                  .read(filePickerProvider)
                  .pickFiles(dialogTitle: 'Escolha um anexo')
                  .then((value) {
                if (value == null) return;
                LoadingSnackbar(
                  contentBuilder: (context) => Text(
                    'Fazendo upload do arquivo...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  errorBuilder: (context, _) => Text(
                    'Houve um erro ao fazer o upload do arquivo!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ).show(
                  context,
                  ref
                      .read(foldersControllerProvider)
                      .addFolderFile(folder.id, value.first),
                );
              }),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attachment_outlined),
                    const SizedBox(width: 4),
                    Text(
                      'Anexar arquivo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/annotations',
                arguments: folder,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).disabledColor,
                ),
                overlayColor: MaterialStateProperty.all(
                  Theme.of(context).splashColor,
                ),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(
                'Visualizar Anotações',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
