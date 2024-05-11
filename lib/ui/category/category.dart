// import 'package:audioplayers/audioplayers.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/providers/category_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/category/category_grid.dart';
import 'package:tiflo_tv/ui/youtube_player_sesli.dart';

class Category extends StatefulWidget {
  final int categoryIndex;
  final String categoryName;
  final List? categoryAudio;

  const Category(
      {super.key,
      required this.categoryIndex,
      required this.categoryAudio,
      required this.categoryName});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with WidgetsBindingObserver {
  @override
  void initState() {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerCategory = context.read<CategoryProvider>();
    WidgetsBinding.instance.addObserver(this);
    providerCategory.indexItem1 = 0;
    if (providerOnBoarding.sliding == 1) {
      providerCategory.initStateCategorySounds(
          providerOnBoarding.categoriesIdWithItems![widget.categoryIndex],
          widget.categoryAudio);
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final providerCategory = context.read<CategoryProvider>();
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      providerCategory.player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerCategory = context.watch<CategoryProvider>();
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final items =
        providerOnBoarding.categoriesIdWithItems?[widget.categoryIndex];
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          await providerCategory.player.stop();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      providerOnBoarding.sliding == 1
                          ? Padding(
                              padding: EdgeInsets.all(6.w),
                              child: SizedBox(
                                height: 24.h,
                                width: 24.w,
                              ))
                          : Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Ink(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                  ),
                                  child: SvgPicture.asset(
                                    AppSvgs.arrowLeft,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),
                              ),
                            ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            widget.categoryName,
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                fontFamily: AppFonts.poppins,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(6.w),
                          child: SizedBox(
                            height: 24.h,
                            width: 24.w,
                          )),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: providerOnBoarding.sliding == 1
                            ? GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onDoubleTap: () async {
                                  items.isNotEmpty
                                      ? await providerCategory.player.stop()
                                      : null;
                                  bool? back = items.isNotEmpty
                                      ? await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  YoutubePlayerSesli(
                                                    id: items[providerCategory
                                                            .indexItem1]
                                                        .id,
                                                  )))
                                      : false;
                                  if (back == true || back == null) {
                                    await providerCategory.onPopSounds(
                                        items, widget.categoryAudio);
                                  }
                                },
                                onVerticalDragEnd: (details) async {
                                  if (details.primaryVelocity! > 0) {
                                    await providerCategory.player.stop();

                                    Navigator.pop(context, true);
                                  }
                                },
                                onHorizontalDragEnd: (details) async {
                                  if (details.primaryVelocity! > 0 &&
                                      items.isNotEmpty) {
                                    providerCategory.onSwipe(
                                        "+", items.length - 1);
                                    final finalHeight =
                                        (providerCategory.indexItem1 / 2) *
                                            providerCategory.heightGridItem;
                                    providerCategory.indexItem1 % 2 == 0 ||
                                            providerCategory.indexItem1 == 0
                                        ? providerCategory.controller.animateTo(
                                            finalHeight,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.linear)
                                        : null;
                                    await providerCategory
                                        .itemsNameSounds(items);
                                  }

                                  if (details.primaryVelocity! < 0 &&
                                      items.isNotEmpty) {
                                    providerCategory.onSwipe(
                                        "-", items.length - 1);

                                    final finalHeight =
                                        ((providerCategory.indexItem1 - 1) /
                                                2) *
                                            providerCategory.heightGridItem;
                                    providerCategory.indexItem1 % 2 != 0 ||
                                            providerCategory.indexItem1 ==
                                                items.length
                                        ? providerCategory.controller.animateTo(
                                            finalHeight,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.linear)
                                        : null;
                                    await providerCategory
                                        .itemsNameSounds(items);
                                  }
                                },
                                child: CategoryGrid(items: items))
                            : CategoryGrid(items: items)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
