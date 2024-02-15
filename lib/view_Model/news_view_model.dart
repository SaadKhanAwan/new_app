import 'package:news_app/models/categoryNewModel.dart';
import 'package:news_app/models/headline_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  // this is instance of NewsRepsotory
  final _rep = NewsRepository();

  Future<NewsChannelHeadLineModel> fetchNewsChannelHeadlineApi(
      String newsname) async {
    final response = await _rep.fetchNewsChannelHeadlineApi(newsname);
    return response;
  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String catrgory) async {
    final response = await _rep.fetchCategoryNewsApi(catrgory);
    return response;
  }
}
