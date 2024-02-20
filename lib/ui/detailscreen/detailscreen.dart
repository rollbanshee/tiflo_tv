import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/item/item.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen_fav_button.dart';
import 'package:tiflo_tv/ui/detailscreen/detailscreen_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  const DetailScreen({required this.id, super.key});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late YoutubePlayerController _controller;
  late Item _dataDetailScreen;

  @override
  void initState() {
    initializeDateFormatting("az_AZ", null);
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerDetailScreen = context.read<DetailScreenProvider>();
    providerDetailScreen.isGetViewsCalled = false;
    _dataDetailScreen = providerOnBoarding.items
        .firstWhere((item) => item.id == widget.id, orElse: () => null);
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(_dataDetailScreen.link!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    )..addListener(() {
        providerDetailScreen.videoListener(
            _controller, _dataDetailScreen.id, _dataDetailScreen)();
      });

    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerDetailScreen = context.watch<DetailScreenProvider>();
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
            overlays: SystemUiOverlay.values);
      },
      onEnterFullScreen: () {},
      player: YoutubePlayer(
        controller: _controller,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.white,
        ),
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
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
                        _dataDetailScreen.name ?? "",
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
                        "${providerDetailScreen.formatDateTime(_dataDetailScreen.date, "az_AZ")} | ${_dataDetailScreen.views.toString()}",
                        style: TextStyle(
                            color: const Color.fromRGBO(199, 199, 199, 1),
                            fontSize: 12.sp,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w400),
                      ),
                      DetailScreenFavButton(
                        dataDetailScreen: _dataDetailScreen,
                      ),
                      Text(
                        _dataDetailScreen.description ?? "",
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
