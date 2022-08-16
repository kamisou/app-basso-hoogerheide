import 'package:basso_hoogerheide/data_objects/app_user.dart';

class Annotations {
  const Annotations({
    required this.description,
    required this.author,
    required this.timestamp,
  });

  final String description;

  final AppUser author;

  final DateTime timestamp;
}