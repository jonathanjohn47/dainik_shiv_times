import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/article_model.dart';
import '../../../models/articles_from_rtdb.dart';
import '../../../models/publisher_model.dart';
import 'home_page_get_controller.dart';

class ArticleTabGetController extends GetxController {
  Future<List<ArticleModel>> loadArticleFromRtdb(String categoryName) async {
    print("Loading Article from RTDB");
    List<ArticleModel> articlesList = [];
    String firebaseUrl =
        "https://dainikshivtimes-b940d-default-rtdb.asia-southeast1.firebasedatabase.app/";

    final response = await http.get(Uri.parse("$firebaseUrl/Articles.json"));

    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      Map<String, dynamic> articles = jsonDecode(response.body);

      print("Total Articles: ${articles.length}");

      articles.forEach((key, value) {
        print("Entered FOREACH statement");
        print("Value: $value");
        ArticlesFromRtdb temp = ArticlesFromRtdb.fromJson(value);

        List<String> receivedCategories = temp.category;
        print("Received Categories: $receivedCategories");

        HomePageGetController homePageGetController = Get.find();
        bool containsCategory = receivedCategories.contains(categoryName);

        print("Contains Category: $containsCategory");

        if (containsCategory) {
          articlesList.add(ArticleModel(
            id: key,
            title: temp.title,
            description: "",
            // Fill as required
            htmlText: temp.content,
            // Fill as required
            date: DateTime.fromMillisecondsSinceEpoch(temp.timestamp),
            // Timestamp in Firebase is in milliseconds, convert to DateTime
            headlineImageUrl: temp.thumbnailImageUrl,
            // Fill as required
            youtubeLink: "",
            // Fill as required
            category: homePageGetController.categories[
                homePageGetController.categories.indexWhere((element) {
              return element.name == categoryName;
            })],
            // Pass the required values and create object
            publisher: PublisherModel(
                name: temp.publisherName,
                email: "email",
                password: "password",
                profilePicLink: "",
                dateCreated: ""),
          ));
        }
      });
    } else {
      throw Exception("Failed to load articles");
    }

    print("Article List Length: ${articlesList.length}");

    return articlesList;
  }
}
