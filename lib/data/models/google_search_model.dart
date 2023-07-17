import 'package:n8_default_project/data/models/organic_model.dart';
import 'package:n8_default_project/data/models/search_parameters_model.dart';

class GoogleSearchModel {
  final SearchParametersModel searchParametersModel;
  final List<OrganicModel> organicModels;

  GoogleSearchModel({
    required this.searchParametersModel,
    required this.organicModels,
  });

  factory GoogleSearchModel.fromJson(Map<String, dynamic> json) {
    return GoogleSearchModel(
      searchParametersModel: SearchParametersModel.fromJson(json["searchParameters"]),
      organicModels: (json["organic"] as List?)
              ?.map((e) => OrganicModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
