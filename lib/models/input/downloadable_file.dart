class DownloadableFile {
  DownloadableFile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        uploadTimestamp = DateTime.parse(json['upload_timestamp']);

  final String name;

  final String url;

  final DateTime uploadTimestamp;
}
