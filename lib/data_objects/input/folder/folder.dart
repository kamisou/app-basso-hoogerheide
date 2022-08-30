import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/address_info.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/annotation.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/contact_info.dart';
import 'package:basso_hoogerheide/data_objects/input/folder/process_info.dart';

abstract class Folder {
  final int id;

  final String name;

  final bool writtenOff;

  final ContactInfo contactInfo;

  final AddressInfo addressInfo;

  final ProcessInfo processInfo;

  final List<DownloadableFile> files;

  final List<Annotation> annotations;

  const Folder({
    required this.id,
    required this.name,
    required this.writtenOff,
    required this.contactInfo,
    required this.addressInfo,
    required this.processInfo,
    required this.files,
    this.annotations = const [],
  });
}