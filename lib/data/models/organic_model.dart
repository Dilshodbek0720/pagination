
class OrganicModel {
  final String title;
  final String link;
  final String snippet;
  final String date;

  OrganicModel({
    required this.title,
    required this.date,
    required this.link,
    required this.snippet,
  });

  factory OrganicModel.fromJson(Map<String, dynamic> json) {
    return OrganicModel(
      title: json["title"] as String? ?? "",
      date: json["date"] as String? ?? "",
      link: json["link"] as String? ?? "",
      snippet: json["snippet"] as String? ?? "",
    );
  }
}
