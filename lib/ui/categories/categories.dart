// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/categories_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/categories/categories_grid.dart';
import 'package:tiflo_tv/ui/category/category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with WidgetsBindingObserver {
  @override
  void initState() {
    final providerCategories = context.read<CategoriesProvider>();
    final providerOnBoarding = context.read<OnBoardingProvider>();
    WidgetsBinding.instance.addObserver(this);
    providerCategories.indexItem1 = 0;
    if (providerOnBoarding.sliding == 1) {
      providerCategories
          .initStateCategoriesSounds(providerOnBoarding.categories);
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final providerCategories = context.read<CategoriesProvider>();
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      providerCategories.player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerCategories = context.watch<CategoriesProvider>();
    final categories = providerOnBoarding.categories;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await providerCategories.player.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kateqoriyalar",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    fontFamily: AppFonts.poppins,
                    color: Theme.of(context).primaryColor),
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: providerOnBoarding.sliding == 1
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTap: () async {
                                categories!.isNotEmpty
                                    ? await providerCategories.player.stop()
                                    : null;
                                bool? back = categories.isNotEmpty
                                    ? await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Category(
                                                categoryAudio: categories[
                                                        providerCategories
                                                            .indexItem1]
                                                    .audio,
                                                categoryIndex:
                                                    providerCategories
                                                        .indexItem1,
                                                categoryName: categories[
                                                        providerCategories
                                                            .indexItem1]
                                                    .category_name)))
                                    : false;
                                if (back == true || back == null) {
                                  await providerCategories
                                      .onPopSounds(categories);
                                }
                              },
                              onVerticalDragEnd: (details) async {
                                if (details.primaryVelocity! > 0) {
                                  await providerCategories.player.stop();
                                  Navigator.pop(context, true);
                                }
                              },
                              onHorizontalDragEnd: (details) async {
                                if (details.primaryVelocity! > 0 &&
                                    categories!.isNotEmpty) {
                                  providerCategories.onSwipe(
                                      "+", categories.length - 1);
                                  final finalHeight =
                                      (providerCategories.indexItem1 / 2) *
                                          providerCategories.heightGridItem;
                                  providerCategories.indexItem1 % 2 == 0 ||
                                          providerCategories.indexItem1 == 0
                                      ? providerCategories.controller.animateTo(
                                          finalHeight,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.linear)
                                      : null;
                                  await providerCategories
                                      .itemsNameSounds(categories);
                                }

                                if (details.primaryVelocity! < 0 &&
                                    categories!.isNotEmpty) {
                                  providerCategories.onSwipe(
                                      "-", categories.length - 1);
                                  final finalHeight =
                                      ((providerCategories.indexItem1 - 1) /
                                              2) *
                                          providerCategories.heightGridItem;
                                  providerCategories.indexItem1 % 2 != 0 ||
                                          providerCategories.indexItem1 ==
                                              categories.length
                                      ? providerCategories.controller.animateTo(
                                          finalHeight,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.linear)
                                      : null;
                                  await providerCategories
                                      .itemsNameSounds(categories);
                                }
                              },
                              child: const CategoriesGrid())
                          : const CategoriesGrid()))
            ],
          ),
        )),
      ),
    );
  }
}
