// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class OnBoardingPartBottom extends StatelessWidget {
  const OnBoardingPartBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Azərbaycan Respublikası Əmək və Əhalinin Sosial Müdafiəsi Nazirliyinin tabeliyində Sosial Xidmətlər Agentliyinin sosial sifarişi ilə bu filmlərin səsləndirilməsi həyata keçirilmişdir.",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                color: const Color.fromRGBO(31, 35, 35, 1),
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40.h,
            ),
            CupertinoSlidingSegmentedControl(
                padding: const EdgeInsets.all(0),
                thumbColor: const Color.fromRGBO(199, 199, 199, 1),
                backgroundColor: const Color.fromRGBO(53, 159, 160, 1),
                children: {
                  0: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Text(
                        "Normal rejim",
                        style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: providerOnBoarding.sliding == 0
                                ? const Color.fromRGBO(239, 81, 64, 1)
                                : const Color.fromRGBO(199, 199, 199, 1)),
                      )),
                  1: Text(
                    "Səsli rejim",
                    style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: providerOnBoarding.sliding == 1
                            ? const Color.fromRGBO(239, 81, 64, 1)
                            : const Color.fromRGBO(199, 199, 199, 1)),
                  ),
                },
                groupValue: providerOnBoarding.sliding,
                onValueChanged: (int? value) async {
                  providerOnBoarding.onValueChanged(value);
                  providerOnBoarding.sliding == 1
                      ? [
                          await providerOnBoarding.player
                              .setAsset(AppSounds.entertocategories),
                          await providerOnBoarding.player.play()
                        ]
                      : providerOnBoarding.player.stop();
                })
          ]),
    );
  }
}
