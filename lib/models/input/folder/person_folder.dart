import 'dart:convert';

import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/address_info.dart';
import 'package:basso_hoogerheide/models/input/folder/annotation.dart';
import 'package:basso_hoogerheide/models/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/input/folder/process_info.dart';

class PersonFolder extends Folder {
  const PersonFolder({
    required int id,
    required String name,
    required bool writtenOff,
    required this.cpf,
    required ContactInfo contactInfo,
    required AddressInfo addressInfo,
    required ProcessInfo processInfo,
    required List<DownloadableFile> files,
    List<Annotation>? annotations,
    this.rg,
  }) : super(
          id: id,
          name: name,
          writtenOff: writtenOff,
          contactInfo: contactInfo,
          addressInfo: addressInfo,
          processInfo: processInfo,
          files: files,
          annotations: annotations ?? const [],
        );

  PersonFolder.fromJson(Map<String, dynamic> js)
      : cpf = js['cpf'],
        rg = js['rg'],
        super(
          addressInfo: AddressInfo.fromJson(js['address_info']),
          annotations: json
              .decodeList<Map<String, dynamic>>(js['annotations'])
              .map(Annotation.fromJson)
              .toList(),
          contactInfo: ContactInfo.fromJson(js['contact_info']),
          files: json
              .decodeList<Map<String, dynamic>>(js['files'])
              .map(DownloadableFile.fromJson)
              .toList(),
          id: js['id'],
          name: js['name'],
          processInfo: ProcessInfo.fromJson(js['process_info']),
          writtenOff: js['written_off'],
        );

  final String cpf;

  final String? rg;
}
