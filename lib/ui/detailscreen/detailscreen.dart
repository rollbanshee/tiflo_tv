// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen_fav_button.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html/parser.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  const DetailScreen({required this.id, super.key});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late YoutubePlayerController controller;
  late Items dataDetailScreen;

  @override
  void initState() {
    initializeDateFormatting("az_AZ", null);
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerDetailScreen = context.read<DetailScreenProvider>();
    providerDetailScreen.isGetViewsCalled = false;
    dataDetailScreen = providerOnBoarding.allLessons!
        .firstWhere((item) => item.id == widget.id, orElse: () => null);
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(dataDetailScreen.link!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    )..addListener(() {
        providerDetailScreen.videoListener(
            controller, dataDetailScreen.id, dataDetailScreen)();
      });

    super.initState();
  }

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerDetailScreen = context.watch<DetailScreenProvider>();
    final String? description = parse(dataDetailScreen.description).body?.text;
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      },
      onEnterFullScreen: () {},
      player: YoutubePlayer(
        controller: controller,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.white,
        ),
      ),
      builder: (context, player) => Scaffold(
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
                      DetailScreenPlayer(player: player),
                      Text(
                        dataDetailScreen.name ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            fontFamily: AppFonts.poppins,
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "${providerDetailScreen.formatDateTime(dataDetailScreen.date, "az_AZ")} | ${dataDetailScreen.views}",
                        style: TextStyle(
                            color: const Color.fromRGBO(199, 199, 199, 1),
                            fontSize: 12.sp,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w400),
                      ),
                      DetailScreenFavButton(
                        dataDetailScreen: dataDetailScreen,
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
      ),
    );
  }
}
