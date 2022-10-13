import 'package:basso_hoogerheide/models/input/app_user.dart';

class Annotation {
  Annotation.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        author = AppUser.fromJson(json['author']),
        createdAt = DateTime.parse(json['created_at']);

  final String description;

  final AppUser author;

  final DateTime createdAt;
}
