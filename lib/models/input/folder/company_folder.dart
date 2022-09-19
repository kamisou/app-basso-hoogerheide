import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/address_info.dart';
import 'package:basso_hoogerheide/models/input/folder/annotation.dart';
import 'package:basso_hoogerheide/models/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/input/folder/process_info.dart';

class CompanyFolder extends Folder {
  CompanyFolder.fromJson(Map<String, dynamic> json)
      : cnpj = json['cnpj'],
        super(
          addressInfo: AddressInfo.fromJson(json['address_info']),
          contactInfo: ContactInfo.fromJson(json['contact_info']),
          files: (json['files'] as List? ?? [])
              .cast<Map<String, dynamic>>()
              .map(DownloadableFile.fromJson)
              .toList(),
          id: json['id'],
          name: json['name'],
          processInfo: ProcessInfo.fromJson(json['process_info']),
          writtenOff: json['written_off'],
          annotations: (json['annotations'] as List? ?? [])
              .cast<Map<String, dynamic>>()
              .map(Annotation.fromJson)
              .toList(),
        );

  final String cnpj;
}
