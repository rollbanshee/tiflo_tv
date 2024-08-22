// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
    final providerOnBoarding = context.read<OnBoardingProvider>();
    // _scale();
    // providerOnBoarding
    // .versionCheck()
    // .getData()
    // .whenComplete(() =>
    providerOnBoarding.getInfoVersion().whenComplete(() {
      Navigator.pushReplacement(context, _createRoute());
    });

    //  );

    super.initState();
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Onboarding(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInToLinear;
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: curve);
          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );
        });
  }

  // _scale() async {
  //   for (var i = 0; i < 200; i++) {
  //     await Future.delayed(const Duration(milliseconds: 1), () {
  //       setState(() {
  //         scaleFactor += 0.005;
  //       });
  //     });
  //   }
  //   Navigator.of(context).push(_createRoute());
  // }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black54));
    super.dispose();
  }

  // double scaleFactor = 1;
  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(child: SvgPicture.asset(AppSvgs.splashScreenLogo)),
      ),
    );
  }
}
