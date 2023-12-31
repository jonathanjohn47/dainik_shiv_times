import 'package:dainik_shiv_times/core/app_colors.dart';
import 'package:dainik_shiv_times/features/home/ui/articles_tab.dart';
import 'package:dainik_shiv_times/features/search/ui/search_page.dart';
import 'package:dainik_shiv_times/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../contact/ui/contact_page.dart';
import '../../e_paper/ui/e_paper_page.dart';
import '../get_controllers/home_page_get_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomePageGetController getController = Get.put(HomePageGetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: getController.categories.length,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/Danik Shiv Time2-05.png',
                  width: 30.w,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Get.to(() => SearchPage());
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
          ),
          body: Obx(() {
            return getController.categories.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Obx(() {
                        return Container(
                          color: AppColors.secondary,
                          child: TabBar(
                            controller: getController.tabController,
                            isScrollable: true,
                            tabs: [
                              ...getController.categories.map((e) => Tab(
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11.sp),
                                    ),
                                  ))
                            ],
                            indicatorColor: Colors.white,
                          ),
                        );
                      }),
                      Expanded(
                        child: Obx(() {
                          return TabBarView(
                              controller: getController.tabController,
                              children: [
                                ...getController.categories
                                    .map((e) => ArticlesTab(
                                          categoryModel: e,
                                        ))
                              ]);
                        }),
                      )
                    ],
                  );
          }),
          drawer: Drawer(
            child: Obx(() {
              return Container(
                child: Column(
                  children: [
                    Container(
                      height: 25.h,
                      width: 100.w,
                      child: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                        child: Image.asset(
                            'assets/images/Danik Shiv Time2-05.png'),
                      )),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        ArticleCategoryModel element =
                            getController.categories[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                element.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              onTap: () {
                                getController.selectedIndex.value =
                                    getController.categories.indexOf(element);
                                getController.tabController.animateTo(
                                    getController.selectedIndex.value);
                                Navigator.pop(context);
                              },
                            ),
                            Divider(
                              thickness: 0.5.sp,
                              color: AppColors.secondary.withOpacity(0.5),
                              indent: 5.w,
                              endIndent: 5.w,
                            )
                          ],
                        );
                      },
                      itemCount: getController.categories.length,
                    ))
                  ],
                ),
              );
            }),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0.sp),
                topRight: Radius.circular(8.sp),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 1.sp,
                  blurRadius: 1.sp,
                  offset: Offset(0, -1.5.sp),
                ),
              ],
              color: AppColors.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //home, contact, share
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.home_filled,
                          color: Colors.white,
                        )),
                    Text('Home', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.to(() => const ContactPage());
                        },
                        icon: Icon(
                          Icons.contact_page,
                          color: Colors.white,
                        )),
                    Text('Contact', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.to(() => EPaperPage());
                        },
                        icon: Icon(
                          Icons.newspaper,
                          color: Colors.white,
                        )),
                    Text('E-Paper', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
