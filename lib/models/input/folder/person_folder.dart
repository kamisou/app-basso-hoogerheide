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

  PersonFolder.fromJson(Map<String, dynamic> json)
      : cpf = json['cpf'],
        rg = json['rg'],
        super(
          addressInfo: AddressInfo.fromJson(json['address_info']),
          annotations: (json['annotations'] as List? ?? [])
              .cast<Map<String, dynamic>>()
              .map(Annotation.fromJson)
              .toList(),
          contactInfo: ContactInfo.fromJson(json['contact_info']),
          files: (json['files'] as List? ?? [])
              .cast<Map<String, dynamic>>()
              .map(DownloadableFile.fromJson)
              .toList(),
          id: json['id'],
          name: json['name'],
          processInfo: ProcessInfo.fromJson(json['process_info']),
          writtenOff: json['written_off'],
        );

  final String cpf;

  final String? rg;
}
