import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/providers/category_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen.dart';

class CategoryGrid extends StatelessWidget {
  final List<Items> categoryItems;

  const CategoryGrid({super.key, required this.categoryItems});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerCategory = context.watch<CategoryProvider>();
    final items = categoryItems;
    double sizeHeight = providerOnBoarding.sliding == 0 ? 4.8 : 4.4;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / sizeHeight;
    final double itemWidth = size.width / 2;
    return
        // providerCategory.isLoading
        //     ? Platform.isAndroid
        //         ? const Center(
        //             child: CircularProgressIndicator(
        //                 strokeWidth: 3, color: Color.fromRGBO(75, 184, 186, 1)))
        //         : const Center(child: CupertinoActivityIndicator())
        //     :
        items.isEmpty
            ? Center(
                child: Text(
                  "Siyahı boşdur",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: const Color.fromRGBO(157, 157, 157, 1),
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp),
                ),
              )
            : GridView.builder(
                controller: providerCategory.controller,
                physics: providerOnBoarding.sliding == 1
                    ? const NeverScrollableScrollPhysics()
                    : null,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 24.w,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (providerOnBoarding.sliding == 0) {
                    return _GridItem(
                      items: items,
                      index: index,
                    );
                  } else if (providerOnBoarding.sliding == 1) {
                    return providerCategory.indexItem1 == index
                        ? Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                                border: Border.all(width: 3, color: Colors.red),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Material(
                                color: Colors.white,
                                child: _GridItem(
                                  items: items,
                                  index: index,
                                )))
                        : Material(
                            color: Colors.white,
                            child: _GridItem(
                              items: items,
                              index: index,
                            ));
                  }
                  return null;
                });
  }
}

class _GridItem extends StatelessWidget {
  final int index;
  final List<dynamic> items;
  const _GridItem({required this.items, required this.index});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();
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
                fit: BoxFit.cover,
                imageUrl: items[index].image != null
                    ? providerOnBoarding.linkStart + items[index].image
                    : providerOnBoarding.imageError,
                placeholder: (context, url) => Platform.isAndroid
                    ? const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color.fromRGBO(75, 184, 186, 1)))
                    : const Center(child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            SvgPicture.asset(
              AppSvgs.playCircle,
              width: 24.w,
              height: 24.h,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                dataDetailScreen: items[index],
                              ),
                            ),
                          );
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
          items[index].name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
