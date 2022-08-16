import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:flutter/material.dart';

class AnnotationsPage extends StatelessWidget {
  const AnnotationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final folder = ModalRoute.of(context)?.settings.arguments as Folder;
    return Scaffold(
      appBar: AppBar(
        title: Text('${folder.id} - ${folder.name}'),
      ),
      body: Row(children: const []),
    );
  }
}
