class SearchParametersModel {
  final String q;
  final int num;
  final int page;
  final String type;

  SearchParametersModel({
    required this.q,
    required this.type,
    required this.num,
    required this.page,
  });

  factory SearchParametersModel.fromJson(Map<String, dynamic> json) {
    return SearchParametersModel(
      q: json["q"] as String? ?? "",
      type: json["type"] as String? ?? "",
      num: json["num"] as int? ?? 0,
      page: json["page"] as int? ?? 0,
    );
  }
}
