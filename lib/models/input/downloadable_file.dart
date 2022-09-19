class DownloadableFile {
  DownloadableFile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        url = json['url'],
        previewUrl = json['preview_url'],
        uploadTimestamp = DateTime.parse(json['upload_timestamp']);

  final int id;

  final String title;

  final String url;

  final String previewUrl;

  final DateTime uploadTimestamp;
}
