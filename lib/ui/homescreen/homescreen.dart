import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/homescreen/homescreen_carousel.dart';
import 'package:tiflo_tv/ui/homescreen/homescreen_carousel_dots.dart';
import 'package:tiflo_tv/ui/homescreen/homescreen_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(75, 184, 186, 1),
      body: SafeArea(
          // bottom: true,
          top: true,
          child: Column(
            children: [
              Container(
                color: const Color.fromRGBO(75, 184, 186, 1),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: const HomeScreenCarousel()),
                    const HomeScreenCarouselDots()
                  ],
                ),
              ),
              const Expanded(child: HomeScreenPartTwo())
            ],
          )),
    );
  }
}

class HomeScreenPartTwo extends StatefulWidget {
  const HomeScreenPartTwo({super.key});

  @override
  State<HomeScreenPartTwo> createState() => _HomeScreenPartTwoState();
}

class _HomeScreenPartTwoState extends State<HomeScreenPartTwo> {
  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();

    return RefreshIndicator(
      strokeWidth: 2,
      displacement: 50,
      backgroundColor: const Color.fromRGBO(75, 184, 186, 1),
      color: Colors.white,
      onRefresh: () async {
        await providerOnBoarding.getData();
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Videolar",
              style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: Theme.of(context).primaryColor),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 16.h,
                      bottom: providerOnBoarding.sliding == 1 ? 16.h : 0),
                  child: const HomeScreenGrid()),
            )
          ],
        ),
      ),
    );
  }
}
