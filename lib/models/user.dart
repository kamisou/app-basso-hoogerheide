class ModelUser {
  final String name;

  final String photoUrl;

  final String sector;

  ModelUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        photoUrl = json['photo_url'],
        sector = json['sector'];
}
