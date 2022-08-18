class DownloadableFile {
  const DownloadableFile({
    required this.title,
    required this.url,
    required this.previewUrl,
    required this.uploadTimestamp,
  });

  final String title;

  final String url;

  final String previewUrl;

  final DateTime uploadTimestamp;
}
