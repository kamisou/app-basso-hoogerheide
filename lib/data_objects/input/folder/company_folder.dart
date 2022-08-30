import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/annotation.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/folder.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/process_info.dart';

class CompanyFolder extends Folder {
  const CompanyFolder({
    required int id,
    required String name,
    required bool writtenOff,
    required this.cnpj,
    required ContactInfo contactInfo,
    required AddressInfo addressInfo,
    required ProcessInfo processInfo,
    required List<DownloadableFile> files,
    List<Annotation>? annotations,
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

  final String cnpj;
}
