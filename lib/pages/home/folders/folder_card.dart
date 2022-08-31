import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/company_folder.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/folder.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/person_folder.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/process_info.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';

class FolderCard extends StatefulWidget {
  const FolderCard({
    super.key,
    required this.folder,
    this.onDeleteFolderFile,
  });

  final void Function(DownloadableFile)? onDeleteFolderFile;

  final Folder folder;

  @override
  State<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: 4,
                    child: ColoredBox(
                      color: widget.folder.processInfo.color,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardHeader(context),
                          Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: _expanded
                                    ? _cardBody(context)
                                    : const SizedBox(
                                        height: 0,
                                        width: double.infinity,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (widget.folder.writtenOff && !_expanded)
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color:
                  Theme.of(context).extension<SuccessThemeExtension>()?.success,
            ),
            margin: const EdgeInsets.only(top: 8, right: 8),
            height: 6,
            width: 6,
          ),
      ],
    );
  }

  Widget _cardHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.folder.id} - ${widget.folder.name}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (widget.folder is PersonFolder)
                  KeyValueText(
                    keyString: 'CPF',
                    valueString: (widget.folder as PersonFolder).cpf,
                  )
                else
                  KeyValueText(
                    keyString: 'CNPJ',
                    valueString: (widget.folder as CompanyFolder).cnpj,
                  ),
                if (_expanded &&
                    widget.folder is PersonFolder &&
                    (widget.folder as PersonFolder).rg != null)
                  KeyValueText(
                    keyString: 'RG',
                    valueString: (widget.folder as PersonFolder).rg!,
                  ),
              ],
            ),
          ),
        ),
        Icon(
          widget.folder is PersonFolder
              ? Icons.person_outline
              : Icons.apartment,
          color: Theme.of(context).disabledColor,
          size: 36,
        ),
      ],
    );
  }

  Widget _cardBody(BuildContext context) {
    final AddressInfo address = widget.folder.addressInfo;
    final ContactInfo contact = widget.folder.contactInfo;
    final ProcessInfo process = widget.folder.processInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.folder.writtenOff)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  Theme.of(context).extension<SuccessThemeExtension>()?.success,
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
        _cardSection(context, Icons.home_outlined, 'Endereço'),
        Text(
          '${address.street} - ${address.district}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '${address.city} - ${address.state}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (address.cep != null)
          Text(
            address.cep!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        _cardSection(context, Icons.phone_outlined, 'Contato'),
        if (contact.email != null)
          KeyValueText(
            keyString: 'E-mail',
            valueString: contact.email!,
          ),
        if (contact.telephone != null)
          KeyValueText(
            keyString: 'Telefone',
            valueString: contact.telephone!,
          ),
        if (contact.cellphone != null)
          KeyValueText(
            keyString: 'Celular',
            valueString: contact.cellphone!,
          ),
        _cardSection(context, Icons.description_outlined, 'Detalhes'),
        KeyValueText(
          keyString: 'Natureza',
          valueString: process.nature,
        ),
        if (process.number != null)
          KeyValueText(
            keyString: 'N° do Processo',
            valueString: process.number!.toString(),
          ),
        if (process.district != null)
          KeyValueText(
            keyString: 'Comarca',
            valueString: process.district!.toString(),
          ),
        if (process.division != null)
          KeyValueText(
            keyString: 'Vara',
            valueString: process.division!.toString(),
          ),
        _cardSection(context, Icons.file_present_outlined, 'Arquivos'),
        ...widget.folder.files.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: widget.onDeleteFolderFile != null
                      ? () => widget.onDeleteFolderFile!(e)
                      : null,
                  child: Icon(
                    Icons.delete_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/annotations',
              arguments: widget.folder,
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
    );
  }

  Widget _cardSection(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
      margin: const EdgeInsets.only(top: 16, bottom: 10),
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
