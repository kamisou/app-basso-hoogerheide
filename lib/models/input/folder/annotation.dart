import 'package:basso_hoogerheide/models/input/app_user.dart';

class Annotation {
  Annotation.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        author = AppUser.fromJson(json['author']),
        timestamp = DateTime.parse(json['timestamp']);

  final String description;

  final AppUser author;

  final DateTime timestamp;
}
