import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen.dart';

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    final providerDetailScreen = context.watch<DetailScreenProvider>();
    final box = providerDetailScreen.box;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              child: box.isEmpty
                  ? Center(
                      child: Text(
                        "Seçilmiş dərslər siyahısı boşdur",
                        style: TextStyle(
                            color: const Color.fromRGBO(157, 157, 157, 1),
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Seçilmişlər",
                          style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: box.keys.length,
                                itemBuilder: (context, index) {
                                  final box = providerDetailScreen.box;
                                  final key = box.keys.toList()[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: index != 0 ? 16.h : 0),
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: SizedBox(
                                                height: 184.h,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                        box.get(key).image ??
                                                            "",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Platform.isAndroid
                                                            ? Center(
                                                                child: SizedBox(
                                                                height: 36.h,
                                                                width: 36.w,
                                                                child: const CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        3,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            75,
                                                                            184,
                                                                            186,
                                                                            1)),
                                                              ))
                                                            : const Center(
                                                                child:
                                                                    CupertinoActivityIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                                Icons.error)),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                                AppSvgs.playCircle),
                                            SizedBox(
                                              height: 184.h,
                                              width: double.infinity,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  splashColor: Colors.white30,
                                                  highlightColor:
                                                      Colors.white24,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailScreen(
                                                                id: box
                                                                    .get(key)
                                                                    .id,
                                                              ))),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          onTap: () {
                                            providerDetailScreen
                                                .deleteFavourite(box.get(key));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(6.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    box.get(key).name,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16.sp),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.w),
                                                  child: SvgPicture.asset(
                                                      AppSvgs.favouriteStar),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ))),
    );
  }
}
