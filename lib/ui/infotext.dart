import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final info = providerOnBoarding.info;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Haqqımızda",
            // textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.poppins,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            '${info?.firstText}\n\n${info?.secondText}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
                fontFamily: AppFonts.poppins),
          )
        ]),
      )),
    );
  }
}
