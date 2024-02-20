import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class DetailScreenFavButton extends StatelessWidget {
  final dynamic dataDetailScreen;

  const DetailScreenFavButton({required this.dataDetailScreen, super.key});

  @override
  Widget build(BuildContext context) {
    final providerDetailScreen = context.watch<DetailScreenProvider>();
    final box = providerDetailScreen.box;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: InkWell(
        onTap: () {
          box.values.toList().any((e) => e.id == dataDetailScreen.id)
              ? providerDetailScreen.deleteFavourite(dataDetailScreen)
              : providerDetailScreen.addFavourite(dataDetailScreen);
          // box.clear();
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(53, 159, 160, 0.24),
              border: Border.all(color: const Color.fromRGBO(53, 159, 160, 1)),
              borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Seçilmişə əlavə et",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                    color: const Color.fromRGBO(53, 159, 160, 1)),
              ),
              !box.values.toList().any((e) => e.id == dataDetailScreen.id)
                  ? SvgPicture.asset(
                      AppSvgs.notFavouriteStar,
                      width: 24.w,
                      height: 24.h,
                    )
                  : SvgPicture.asset(
                      AppSvgs.favouriteStar,
                      width: 24.w,
                      height: 24.h,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
