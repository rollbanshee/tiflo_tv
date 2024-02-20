import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/item/item.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerSesli extends StatefulWidget {
  final int id;
  const YoutubePlayerSesli({required this.id, super.key});
  @override
  State<YoutubePlayerSesli> createState() => _YoutubePlayerSesliState();
}

class _YoutubePlayerSesliState extends State<YoutubePlayerSesli> {
  late YoutubePlayerController controller;
  late Item dataDetailScreen;
  final playerSesliYoutube = AudioPlayer();
  @override
  void initState() {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerDetailScreen = context.read<DetailScreenProvider>();
    playAudio();
    providerDetailScreen.isGetViewsCalled = false;
    dataDetailScreen = providerOnBoarding.items
        .firstWhere((item) => item.id == widget.id, orElse: () => null);
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(dataDetailScreen.link!)!,
      flags: const YoutubePlayerFlags(
          autoPlay: false, hideControls: true, disableDragSeek: true),
    )..addListener(() {
        providerDetailScreen.videoListener(
            controller, dataDetailScreen.id, dataDetailScreen)();
      });
    super.initState();
  }

  void playAudio() async {
    await playerSesliYoutube.play(AssetSource(AppSounds.navinfovideo));
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await playerSesliYoutube.stop();
        return true;
      },
      child: GestureDetector(
        onDoubleTap: () async {
          await playerSesliYoutube.stop();
          controller.value.isPlaying ? controller.pause() : controller.play();
        },
        onHorizontalDragEnd: (details) => details.primaryVelocity! > 0
            ? controller.seekTo(
                Duration(seconds: controller.value.position.inSeconds + 10))
            : controller.seekTo(
                Duration(seconds: controller.value.position.inSeconds - 10)),
        onVerticalDragEnd: (details) async {
          details.primaryVelocity! > 0
              // ignore: use_build_context_synchronously
              ? [await playerSesliYoutube.stop(), Navigator.pop(context, true)]
              : null;
        },
        child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: controller,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.white,
                // backgroundColor: Colors.white,
              ),
            ),
            builder: (context, player) => Scaffold(
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: player)),
                  ),
                )),
      ),
    );
  }
}
