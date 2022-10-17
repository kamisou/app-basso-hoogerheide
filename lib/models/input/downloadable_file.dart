class DownloadableFile {
  DownloadableFile.fromJson(Map<String, dynamic> json)
      : filename = json['filename'],
        url = json['url'],
        uploadTimestamp = DateTime.parse(json['upload_timestamp']);

  final String filename;

  final String url;

  final DateTime uploadTimestamp;
}
