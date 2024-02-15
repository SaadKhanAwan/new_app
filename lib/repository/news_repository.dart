import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categoryNewModel.dart';
import 'package:news_app/models/headline_model.dart';

class NewsRepository {
  Future<NewsChannelHeadLineModel> fetchNewsChannelHeadlineApi(
      String newsname) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$newsname&apiKey=4219662599f64546b1d7d8072dce5c30";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = response.body;
      var data = jsonDecode(body);
      return NewsChannelHeadLineModel.fromJson(data);
    }
    throw Exception("error");
  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=4219662599f64546b1d7d8072dce5c30";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = response.body;
      var data = jsonDecode(body);
      return CategoryNewsModel.fromJson(data);
    }
    throw Exception("error");
  }
}
