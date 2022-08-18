import 'package:basso_hoogerheide/data_objects/contact.dart';
import 'package:basso_hoogerheide/widgets/avatar_circle.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final TextStyle? detailStyle = Theme.of(context).textTheme.labelMedium;
    return Row(
      children: [
        AvatarCircle(
          initials: contact.initials,
          avatarUrl: contact.avatarUrl,
          radius: 48,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  if (contact.telephone != null)
                    Flexible(
                      child: KeyValueText(
                        keyString: 'Tel',
                        valueString: contact.telephone!,
                        style: detailStyle,
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (contact.celullar != null)
                    Flexible(
                      child: KeyValueText(
                        keyString: 'Cel',
                        valueString: contact.celullar!,
                        style: detailStyle,
                      ),
                    ),
                ],
              ),
              if (contact.email != null)
                KeyValueText(
                  keyString: 'Email',
                  valueString: contact.email!,
                  style: detailStyle,
                ),
              if (contact.fax != null)
                KeyValueText(
                  keyString: 'Fax',
                  valueString: contact.fax!,
                  style: detailStyle,
                ),
              if (contact.address != null)
                KeyValueText(
                  keyString: 'Endereço',
                  valueString: contact.address!,
                  style: detailStyle,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
