import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/address_info.dart';
import 'package:basso_hoogerheide/models/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/input/folder/process_info.dart';
import 'package:basso_hoogerheide/models/repository/folders.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class FolderCard extends ConsumerStatefulWidget {
  const FolderCard({
    super.key,
    required this.folder,
    this.onDeleteFolderFile,
  });

  final void Function(DownloadableFile)? onDeleteFolderFile;

  final Folder folder;

  @override
  ConsumerState<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends ConsumerState<FolderCard> {
  TapDownDetails? _tapDetails;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            onTapDown: (details) => _tapDetails = details,
            onLongPress: _onLongPress,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: 4,
                    child: ColoredBox(
                      color: widget.folder.processInfo.color.withOpacity(1),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardHeader(),
                          Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: _expanded
                                    ? _cardBody()
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

  Widget _cardHeader() {
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
                KeyValueText(
                  keyString: 'CPF',
                  valueString: widget.folder.cpf,
                ),
                if (_expanded && (widget.folder.rg?.isNotEmpty ?? false))
                  KeyValueText(
                    keyString: 'RG',
                    valueString: widget.folder.rg!,
                  ),
              ],
            ),
          ),
        ),
        Icon(
          Icons.person_outline,
          color: Theme.of(context).disabledColor,
          size: 36,
        ),
      ],
    );
  }

  Widget _cardBody() {
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
        _cardSection(Icons.home_outlined, 'Endereço'),
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
        _cardSection(Icons.phone_outlined, 'Contato'),
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
        _cardSection(Icons.description_outlined, 'Detalhes'),
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
        _cardSection(Icons.file_present_outlined, 'Arquivos'),
        ...widget.folder.files.map(
          (e) => InkWell(
            onTap: () => launchUrl(
              Uri.parse('${e.url}?token=${ref.read(authTokenProvider)}'),
              mode: LaunchMode.externalApplication,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
        InkWell(
          onTap: () => ref
              .read(filePickerProvider)
              .pickFiles(dialogTitle: 'Escolha um anexo')
              .then((value) {
            if (value == null) return;
            ref
                .read(foldersRepositoryProvider)
                .addFolderFile(widget.folder.id, value.first)
                .then(
                  (_) => ref.refresh(foldersProvider),
                  onError: (e) => ErrorSnackbar(
                    context: context,
                    error: e,
                  ).on<RestException>(
                    content: (error) => ErrorContent(
                      message: error.serverMessage,
                    ),
                  ),
                );
          }),
          borderRadius: BorderRadius.circular(4),
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

  Widget _cardSection(IconData icon, String title) {
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

  void _onLongPress() async {
    if (_tapDetails == null) return;
    final double dx = _tapDetails!.globalPosition.dx;
    final double dy = _tapDetails!.globalPosition.dy;
    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      items: [
        const PopupMenuItem(value: 'edit', child: Text('Editar pasta')),
        PopupMenuItem(
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
          value: 'delete',
          child: const Text('Deletar pasta'),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        Navigator.pushNamed(context, '/newFolder', arguments: widget.folder.id);
      } else if (value == 'delete') {
        ref
            .read(foldersRepositoryProvider)
            .deleteFolder(widget.folder)
            .catchError(
              (e) => ErrorSnackbar(
                context: context,
                error: e,
              ).on<RestException>(
                content: (error) => ErrorContent(message: error.serverMessage),
              ),
            );
      }
    });
  }
}
