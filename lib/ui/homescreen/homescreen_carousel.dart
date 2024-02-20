import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/homescreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen.dart';

class HomeScreenCarousel extends StatelessWidget {
  const HomeScreenCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final providerHomeScreen = context.watch<HomeScreenProvider>();
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    final data = providerOnBoarding.data;
    return CarouselSlider.builder(
      itemCount: 4,
      itemBuilder: (context, index, realIndex) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(children: [
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                  imageUrl: data?[0].items[index].image ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Platform.isAndroid
                      ? Center(
                          child: Center(
                              child: SizedBox(
                            height: 36.h,
                            width: 36.w,
                            child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color.fromRGBO(75, 184, 186, 1)),
                          )),
                        )
                      : const Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error)),
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.25,
              child: Text(
                data?[0].items[index].name,
                style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppSvgs.playCircle,
              width: 40.w,
              height: 40.h,
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            child: InkWell(
              splashColor: Colors.white30,
              highlightColor: Colors.white24,
              borderRadius: BorderRadius.circular(8.r),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      id: data?[0].items[index].id,
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      options: CarouselOptions(
        autoPlay: false,
        autoPlayAnimationDuration: const Duration(seconds: 2),
        onPageChanged: (index, reason) =>
            providerHomeScreen.onPageChanged(index),
        height: 169.h,
        viewportFraction: 1,
        // aspectRatio: 3 / 1.5
      ),
    );
  }
}
