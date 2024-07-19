// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen_fav_button.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen_player.dart';
import 'package:html/parser.dart';

class DetailScreen extends StatefulWidget {
  final Items dataDetailScreen;

  const DetailScreen({super.key, required this.dataDetailScreen});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final PodPlayerController controller;

  @override
  void initState() {
    initializeDateFormatting("az_AZ", null);
    // final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerDetailScreen = context.read<DetailScreenProvider>();
    // providerDetailScreen.isGetViewsCalled = false;
    // providerDetailScreen.getVimeoVideoData(int.parse(dataDetailScreen.link!));

    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(
          widget.dataDetailScreen.link.toString(),
        ),
        podPlayerConfig: const PodPlayerConfig(autoPlay: false))
      ..initialise();
    providerDetailScreen.postViews(widget.dataDetailScreen.id);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerDetailScreen = context.watch<DetailScreenProvider>();
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final String? description =
        parse(widget.dataDetailScreen.description).body?.text;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
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
            SizedBox(
              height: 16.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailScreenPlayer(
                        // player:
                        //  AspectRatio(
                        //   aspectRatio: 16 / 9,
                        //   child: WebViewWidget(
                        //     controller: providerDetailScreen.controllerWebView,
                        //   ),
                        // ),
                        player: PodVideoPlayer(
                      videoThumbnail: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.dataDetailScreen.image != null
                              ? providerOnBoarding.linkStart +
                                  widget.dataDetailScreen.image.toString()
                              : providerOnBoarding.imageError,
                        ),
                      ),
                      controller: controller,
                    )),
                    Text(
                      widget.dataDetailScreen.name ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          fontFamily: AppFonts.poppins,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    providerDetailScreen.views == null
                        ? Padding(
                            padding: const EdgeInsets.all(6),
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: Platform.isAndroid
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Color.fromRGBO(199, 199, 199, 1),
                                    )
                                  : const CupertinoActivityIndicator(
                                      color: Color.fromRGBO(199, 199, 199, 1),
                                    ),
                            ),
                          )
                        : Text(
                            "${providerDetailScreen.formatDateTime(widget.dataDetailScreen.date, "az_AZ")} | ${providerDetailScreen.views}",
                            style: TextStyle(
                                color: const Color.fromRGBO(199, 199, 199, 1),
                                fontSize: 12.sp,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.w400),
                          ),
                    DetailScreenFavButton(
                      dataDetailScreen: widget.dataDetailScreen,
                    ),
                    Text(
                      description ?? "",
                      style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
