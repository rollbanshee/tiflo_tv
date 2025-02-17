// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:tiflo_tv/features/domain/models/categories/categories.dart';
import 'package:tiflo_tv/features/providers/categories_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/category/category.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerCategories = context.watch<CategoriesProvider>();
    final categories = providerOnBoarding.box.get('categories') ?? [];
    double sizeHeight = providerOnBoarding.sliding == 0 ? 4.8 : 4.4;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / sizeHeight;
    final double itemWidth = size.width / 2;
    return
        // providerCategories.isLoading
        //     ? Platform.isAndroid
        //         ? const Center(
        //             child: CircularProgressIndicator(
        //                 strokeWidth: 3, color: Color.fromRGBO(75, 184, 186, 1)))
        //         : const Center(child: CupertinoActivityIndicator())
        //     :
        categories.isEmpty
            ? Center(
                child: Text(
                "Siyahı boşdur",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color.fromRGBO(157, 157, 157, 1),
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp),
              ))
            : GridView.builder(
                controller: providerCategories.controller,
                physics: providerOnBoarding.sliding == 1
                    ? const NeverScrollableScrollPhysics()
                    : null,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 24.w,
                    childAspectRatio: (itemWidth / itemHeight)),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  if (providerOnBoarding.sliding == 0) {
                    return _GridItem(
                      categories: categories,
                      index: index,
                    );
                  } else if (providerOnBoarding.sliding == 1) {
                    return providerCategories.indexItem1 == index
                        ? Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                                // color: Colors.black,
                                border: Border.all(width: 3, color: Colors.red),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Material(
                                color: Colors.white,
                                child: _GridItem(
                                    index: index, categories: categories)))
                        : Material(
                            color: Colors.white,
                            child: _GridItem(
                                index: index, categories: categories));
                  }
                  return null;
                });
  }
}

class _GridItem extends StatelessWidget {
  final List categories;
  final int index;
  const _GridItem({required this.categories, required this.index});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    final providerCategories = context.read<CategoriesProvider>();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                width: double.infinity,
                height: 88.h,
                imageUrl: categories[index].image != null
                    ? providerOnBoarding.linkStart + categories[index].image!
                    : providerOnBoarding.imageError,
                fit: BoxFit.cover,
                placeholder: (context, url) => Platform.isAndroid
                    ? const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color.fromRGBO(75, 184, 186, 1)))
                    : const Center(child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            providerOnBoarding.sliding == 0
                ? SizedBox(
                    height: 88.h,
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      child: InkWell(
                        splashColor: Colors.white30,
                        highlightColor: Colors.white24,
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () async {
                          await providerCategories.player.stop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen(
                                        categoryItems:
                                            categories[index].lessons,
                                        categoryAudio: categories[index].audio,
                                        categoryName:
                                            categories[index].category_name,
                                        // category: categories[index],
                                      )));
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          categories[index].category_name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
        )
      ],
    );
  }
}
