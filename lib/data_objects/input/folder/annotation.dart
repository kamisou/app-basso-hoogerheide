import 'package:basso_hoogerheide/data_objects/input/app_user.dart';

class Annotation {
  const Annotation({
    required this.description,
    required this.author,
    required this.timestamp,
  });

  final String description;

  final AppUser author;

  final DateTime timestamp;
}