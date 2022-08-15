import 'package:basso_hoogerheide/data_objects/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/folder/file.dart';
import 'package:basso_hoogerheide/data_objects/folder/process_info.dart';

abstract class Folder {
  final int id;

  final String name;

  final bool writtenOff;

  final ContactInfo contactInfo;

  final AddressInfo addressInfo;

  final ProcessInfo processInfo;

  final List<FolderFile> files;

  const Folder({
    required this.id,
    required this.name,
    required this.writtenOff,
    required this.contactInfo,
    required this.addressInfo,
    required this.processInfo,
    required this.files,
  });
}
