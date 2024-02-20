import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      // _scale();
      Navigator.push(context, _createRoute());
    });
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  // double scaleFactor = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: SvgPicture.asset(AppSvgs.splashScreenLogo),
        ),
      ),
    );
  }
}
