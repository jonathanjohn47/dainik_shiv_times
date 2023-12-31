import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dainik_shiv_times/core/app_colors.dart';
import 'package:dainik_shiv_times/helpers/date_time_helpers.dart';
import 'package:dainik_shiv_times/models/article_model.dart';
import 'package:dainik_shiv_times/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../article_details/ui/article_details_page.dart';
import '../get_controllers/article_tab_get_controller.dart';

class ArticlesTab extends StatelessWidget {
  final ArticleCategoryModel categoryModel;

  ArticlesTab({super.key, required this.categoryModel});

  ArticleTabGetController getController = Get.put(ArticleTabGetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ArticleModel>>(
          future: getController.loadArticleFromRtdb(categoryModel.name),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ArticleModel> allArticles = snapshot.data!;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                child: allArticles.length < 5
                    ? ListView(
                        children: [
                          ...allArticles.map((e) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ArticleDetailsPage(
                                      articleModel: e,
                                    ));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.sp),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.title,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                            child: e.headlineImageUrl.isNotEmpty
                                                ? Image.network(
                                                    e.headlineImageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 20.w,
                                                    height: 20.w,
                                                  )
                                                : Image.asset(
                                                    'assets/images/Danik Shiv Time2-05.png',
                                                    fit: BoxFit.cover,
                                                    width: 20.w,
                                                    height: 20.w,
                                                  )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.sp),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Published: ${e.date.toDateWithShortMonthNameAndTime}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.sp),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10.sp,
                                          backgroundImage: NetworkImage(
                                              e.publisher.profilePicLink),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          e.publisher.name,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5.sp,
                                    color: AppColors.secondary.shade50
                                        .withOpacity(0.5),
                                    indent: 8.w,
                                    endIndent: 8.w,
                                  )
                                ],
                              ),
                            );
                          }).toList()
                        ],
                      )
                    : ListView(
                        children: [
                          CarouselSlider(
                              items: allArticles.sublist(0, 5).map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => ArticleDetailsPage(
                                          articleModel: e,
                                        ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0.sp),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                            child: e.headlineImageUrl.isNotEmpty
                                                ? Image.network(
                                                    e.headlineImageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 100.w,
                                                    height: 25.h,
                                                  )
                                                : Image.asset(
                                                    'assets/images/Danik Shiv Time2-05.png',
                                                    fit: BoxFit.cover,
                                                    width: 20.w,
                                                    height: 20.w,
                                                  )),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  e.title,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 0.5.sp,
                                          color: AppColors.secondary.shade50
                                              .withOpacity(0.5),
                                          indent: 8.w,
                                          endIndent: 8.w,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              options: CarouselOptions(
                                height: 40.h,
                                autoPlay: true,
                                viewportFraction: 0.9,
                              )),
                          ...allArticles.sublist(5).map((e) {
                            return GestureDetector(
                              onTap: () {
                                print(e.toJson());
                                Get.to(() => ArticleDetailsPage(
                                      articleModel: e,
                                    ));
                              },
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.sp),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.title,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                            child: e.headlineImageUrl.isNotEmpty
                                                ? Image.network(
                                                    e.headlineImageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 20.w,
                                                    height: 20.w,
                                                  )
                                                : Image.asset(
                                                    'assets/images/Danik Shiv Time2-05.png',
                                                    fit: BoxFit.cover,
                                                    width: 20.w,
                                                    height: 20.w,
                                                  )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.sp),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Published: ${e.date.toDateWithShortMonthNameAndTime}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5.sp,
                                    color: AppColors.secondary.shade50
                                        .withOpacity(0.5),
                                    indent: 8.w,
                                    endIndent: 8.w,
                                  )
                                ],
                              ),
                            );
                          }).toList()
                        ],
                      ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
