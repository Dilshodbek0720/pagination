import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:n8_default_project/data/models/google_search_model.dart';

import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/network_utils.dart';
import 'package:n8_default_project/utils/constants.dart';

class ApiProvider {
  static Future<UniversalData> searchFromGoogle({
    required String query,
    required int page,
    required int count,
  }) async {
    Uri uri = Uri.https(
      baseUrl,
      "/search",
      {
        "q": query,
        "page": page.toString(),
        "num": count.toString(),
        "gl":"uz"
      },
    );

    try {
      http.Response response = await http.post(uri, headers: {
        "Content-Type": "application/json",
        "X-API-KEY": "68a18cafb048059571d5286c2905420498357f74",
      });

      if (response.statusCode == HttpStatus.ok) {
        return UniversalData(
            data: GoogleSearchModel.fromJson(jsonDecode(response.body)));
      }
      return handleHttpErrors(response);
    } on SocketException {
      return UniversalData(error: "Internet Error!");
    } on FormatException {
      return UniversalData(error: "Format Error!");
    } catch (err) {
      debugPrint("ERROR:$err. ERROR TYPE: ${err.runtimeType}");
      return UniversalData(error: err.toString());
    }
  }
}
