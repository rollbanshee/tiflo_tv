import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/homescreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';

class HomeScreenCarouselDots extends StatelessWidget {
  const HomeScreenCarouselDots({super.key});

  @override
  Widget build(BuildContext context) {
    final providerHomeScreen = context.watch<HomeScreenProvider>();
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    final sliders = providerOnBoarding.homeSliders;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0; i < (sliders?.length ?? 4); i++)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == providerHomeScreen.index
                    ? const Color.fromRGBO(239, 81, 64, 1)
                    : const Color.fromRGBO(23, 93, 94, 1)),
          )
      ]),
    );
  }
}
