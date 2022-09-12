import 'package:basso_hoogerheide/models/input/app_user.dart';

class Annotation {
  const Annotation({
    required this.description,
    required this.author,
    required this.timestamp,
  });

  Annotation.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        author = AppUser.fromJson(json['author']),
        timestamp = DateTime.parse(json['timestamp']);

  final String description;

  final AppUser author;

  final DateTime timestamp;
}
