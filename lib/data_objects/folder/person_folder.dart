import 'package:basso_hoogerheide/data_objects/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/annotations.dart';
import 'package:basso_hoogerheide/data_objects/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/file.dart';
import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/process_info.dart';

class PersonFolder extends Folder {
  const PersonFolder({
    required int id,
    required String name,
    required bool writtenOff,
    required this.cpf,
    required ContactInfo contactInfo,
    required AddressInfo addressInfo,
    required ProcessInfo processInfo,
    required List<FolderFile> files,
    required List<Annotations> annotations,
    required DateTime timestamp,
    this.rg,
  }) : super(
          id: id,
          name: name,
          writtenOff: writtenOff,
          contactInfo: contactInfo,
          addressInfo: addressInfo,
          processInfo: processInfo,
          files: files,
          annotations: annotations,
          timestamp: timestamp,
        );

  final String cpf;

  final String? rg;
}
