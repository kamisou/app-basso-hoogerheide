import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/address_info.dart';
import 'package:basso_hoogerheide/models/input/folder/annotation.dart';
import 'package:basso_hoogerheide/models/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/models/input/folder/process_info.dart';

class Folder {
  Folder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        cpf = json['cpf'],
        rg = json['rg'],
        addressInfo = AddressInfo.fromJson(json['address_info']),
        annotations = (json['annotations'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(Annotation.fromJson)
            .toList(),
        contactInfo = ContactInfo.fromJson(json['contact_info']),
        files = (json['files'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(DownloadableFile.fromJson)
            .toList(),
        processInfo = ProcessInfo.fromJson(json['process_info']),
        writtenOff = json['written_off'];

  final int id;

  final String cpf;

  final String? rg;

  final String name;

  final bool writtenOff;

  final ContactInfo contactInfo;

  final AddressInfo addressInfo;

  final ProcessInfo processInfo;

  final List<DownloadableFile> files;

  final List<Annotation> annotations;
}
