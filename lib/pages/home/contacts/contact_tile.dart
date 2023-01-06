import 'package:basso_hoogerheide/controllers/contacts.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/contact.dart';
import 'package:basso_hoogerheide/widgets/avatar_circle.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactTile extends ConsumerStatefulWidget {
  const ContactTile({
    super.key,
    required this.contact,
    this.editable = true,
  });

  final Contact contact;

  final bool editable;

  @override
  ConsumerState<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends ConsumerState<ContactTile> {
  TapDownDetails? _tapDetails;

  @override
  Widget build(BuildContext context) {
    final TextStyle? detailStyle = Theme.of(context).textTheme.labelMedium;
    final Widget child = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      child: Row(
        children: [
          AvatarCircle(initials: widget.contact.initials, radius: 48),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    if (widget.contact.telephone?.isNotEmpty ?? false) ...[
                      Flexible(
                        child: KeyValueText(
                          keyString: 'Tel',
                          valueString: widget.contact.telephone!,
                          style: detailStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (widget.contact.cellphone?.isNotEmpty ?? false)
                      Flexible(
                        child: KeyValueText(
                          keyString: 'Cel',
                          valueString: widget.contact.cellphone!,
                          style: detailStyle,
                        ),
                      ),
                  ],
                ),
                if (widget.contact.email?.isNotEmpty ?? false)
                  KeyValueText(
                    keyString: 'Email',
                    valueString: widget.contact.email!,
                    style: detailStyle,
                  ),
                if (widget.contact.fax != null)
                  KeyValueText(
                    keyString: 'Fax',
                    valueString: widget.contact.fax!,
                    style: detailStyle,
                  ),
                if (widget.contact.address != null)
                  KeyValueText(
                    keyString: 'Endereço',
                    valueString: widget.contact.address!,
                    style: detailStyle,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return widget.editable
        ? InkWell(
            onTapDown: (details) => setState(() => _tapDetails = details),
            onLongPress: widget.editable ? _onLongPress : null,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: child,
          )
        : child;
  }

  void _onLongPress() async {
    if (_tapDetails == null) return;
    final double dx = _tapDetails!.globalPosition.dx;
    final double dy = _tapDetails!.globalPosition.dy;
    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      items: [
        const PopupMenuItem(value: 'edit', child: Text('Editar contato')),
        PopupMenuItem(
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
          value: 'delete',
          child: const Text('Deletar contato'),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        Navigator.pushNamed(context, '/newContact', arguments: widget.contact);
      } else if (value == 'delete') {
        ref
            .read(contactsControllerProvider)
            .deleteContact(widget.contact)
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
