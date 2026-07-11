class RecentDocument {
  final String filePath;
  final String title;
  final DateTime lastOpened;

  const RecentDocument({
    required this.filePath,
    required this.title,
    required this.lastOpened,
  });

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'title': title,
        'lastOpened': lastOpened.toIso8601String(),
      };

  factory RecentDocument.fromJson(Map<String, dynamic> json) => RecentDocument(
        filePath: json['filePath'] as String,
        title: json['title'] as String,
        lastOpened: DateTime.parse(json['lastOpened'] as String),
      );

  RecentDocument copyWith({String? title, DateTime? lastOpened}) =>
      RecentDocument(
        filePath: filePath,
        title: title ?? this.title,
        lastOpened: lastOpened ?? this.lastOpened,
      );
}
