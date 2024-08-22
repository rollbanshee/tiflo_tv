import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen.dart';

class HomeScreenGrid extends StatelessWidget {
  const HomeScreenGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.watch<OnBoardingProvider>();
    final lessons = providerOnBoarding.box.get('homeLessons');
    double sizeHeight = 4.8;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / sizeHeight;
    final double itemWidth = size.width / 2;
    return lessons == null || lessons.isEmpty
        ? Center(
            child: Text(
              "Siyahı boşdur",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color.fromRGBO(157, 157, 157, 1),
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp),
            ),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 24.w,
                childAspectRatio: (itemWidth / itemHeight)),
            itemCount: lessons.length,
            itemBuilder: (context, index) => _GridItem(
                  items: lessons,
                  index: index,
                ));
  }
}

class _GridItem extends StatelessWidget {
  final List<dynamic> items;
  final int index;
  const _GridItem({required this.items, required this.index});

  @override
  Widget build(BuildContext context) {
    final providerOnBoarding = context.read<OnBoardingProvider>();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                width: double.infinity,
                height: 88.h,
                imageUrl: items[index].image != null
                    ? providerOnBoarding.linkStart + items[index].image
                    : providerOnBoarding.imageError,
                fit: BoxFit.cover,
                placeholder: (context, url) => Platform.isAndroid
                    ? const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color.fromRGBO(75, 184, 186, 1)))
                    : const Center(child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            SvgPicture.asset(
              AppSvgs.playCircle,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(
              height: 88.h,
              width: double.infinity,
              child: Material(
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
                          dataDetailScreen: items[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        LayoutBuilder(builder: (context, constraints) {
          return Text(
            items[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: constraints.maxWidth > 250 ? 10.sp : 12.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600),
          );
        }),
      ],
    );
  }
}
