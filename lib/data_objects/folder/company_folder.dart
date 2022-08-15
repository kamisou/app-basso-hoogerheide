import 'package:basso_hoogerheide/data_objects/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/file.dart';
import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/data_objects/folder/process_info.dart';

class CompanyFolder extends Folder {
  const CompanyFolder({
    required int id,
    required String name,
    required bool writtenOff,
    required this.cnpj,
    required ContactInfo contactInfo,
    required AddressInfo addressInfo,
    required ProcessInfo processInfo,
    required List<FolderFile> files,
  }) : super(
          id: id,
          name: name,
          writtenOff: writtenOff,
          contactInfo: contactInfo,
          addressInfo: addressInfo,
          processInfo: processInfo,
          files: files,
        );

  final String cnpj;
}