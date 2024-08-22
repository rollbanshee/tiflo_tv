// ignore_for_file: use_build_context_synchronously
// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/bottomnavbar.dart';
import 'package:tiflo_tv/ui/categories/categories.dart';
import 'package:tiflo_tv/ui/onboarding/onboardingbottom.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    final providerOnBoarding = context.read<OnBoardingProvider>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    providerOnBoarding.getData();
    // });
    // scale();
    super.initState();
  }

  // scale() async {
  //   for (var i = 0; i < 200; i++) {
  //     await Future.delayed(const Duration(milliseconds: 1), () {
  //       setState(() {
  //         scaleFactor -= 0.005;
  //       });
  //     });
  //   }
  // }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final providerOnBoarding = context.read<OnBoardingProvider>();
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      providerOnBoarding.player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) async {
              if (details.primaryVelocity! > 0) {
                providerOnBoarding.onSwipe(1);
                await providerOnBoarding.player.stop();
                await providerOnBoarding.player
                    .setAsset(AppSounds.entertocategories);
                await providerOnBoarding.player.play();
              }

              if (details.primaryVelocity! < 0) {
                providerOnBoarding.onSwipe(0);
                await providerOnBoarding.player.stop();
              }
            },
            onDoubleTap: () async {
              if (providerOnBoarding.sliding == 1) {
                await providerOnBoarding.player.stop();
                // await providerOnBoarding.getDataOnboarding(context);
                bool? back = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriesScreen()));
                if (back == true || back == null) {
                  await providerOnBoarding.player.stop();
                  await providerOnBoarding.player.setAsset(AppSounds.mainpage);
                  await providerOnBoarding.player.play();
                }
              }
            },
            onTap: () async => providerOnBoarding.sliding == 0
                ? [
                    await providerOnBoarding.player.stop(),
                    // await providerOnBoarding.getDataOnboarding(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar())),
                  ]
                : [
                    await providerOnBoarding.player.stop(),
                    await providerOnBoarding.player
                        .setAsset(AppSounds.entertocategories),
                    await providerOnBoarding.player.play()
                  ],
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: Column(children: [
                      Container(
                          width: double.infinity,
                          height: 526.h,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(53, 159, 160, 1),
                              image: DecorationImage(
                                  image: AssetImage(
                                      AppImages.onboardingBackground4K),
                                  colorFilter: ColorFilter.mode(
                                      Colors.black12, BlendMode.dstATop),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: SvgPicture.asset(AppSvgs.onboardingLogo),
                          )),
                    ]),
                  ),
                  const OnBoardingPartBottom()
                ],
              ),
            ),
          ),
          Visibility(
              visible: providerOnBoarding.isDataLoading,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    backgroundBlendMode: BlendMode.dstATop),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromARGB(255, 53, 158, 160),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${(providerOnBoarding.progressValue * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp),
                        ),
                        CircularProgressIndicator(
                            strokeAlign: 3,
                            color: Colors.white,
                            value: providerOnBoarding.progressValue),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
