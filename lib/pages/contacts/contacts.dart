import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:flutter/material.dart';

class ContactsPage extends HomePageBody {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => const Text('A'),
    );
  }

  @override
  VoidCallback? get fabAction => null;

  @override
  String get title => 'Contatos';
}
