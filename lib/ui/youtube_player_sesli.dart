// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';
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

class _YoutubePlayerSesliState extends State<YoutubePlayerSesli>
    with WidgetsBindingObserver {
  late Items dataDetailScreen;
  final playerSesliYoutube = AudioPlayer();
  late YoutubePlayerController controller;
  @override
  void initState() {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerDetailScreen = context.read<DetailScreenProvider>();
    WidgetsBinding.instance.addObserver(this);
    playAudio();
    providerDetailScreen.isGetViewsCalled = false;
    dataDetailScreen = providerOnBoarding.allLessons!
        .firstWhere((item) => item.id == widget.id, orElse: () => null);
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(dataDetailScreen.link!)!,
      flags: const YoutubePlayerFlags(
          autoPlay: false, hideControls: true, disableDragSeek: true),
    );
    playerSesliYoutube.playerStateStream.listen((event) {
      event.processingState == ProcessingState.completed
          ? controller.play()
          : null;
    });

    controller.addListener(() {
      providerDetailScreen.videoListener(
          controller, dataDetailScreen.id, dataDetailScreen);
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      playerSesliYoutube.stop();
    }
  }

  void playAudio() async {
    await playerSesliYoutube.setAsset(AppSounds.navinfovideo);
    await playerSesliYoutube.play();
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
    return WillPopScope(
      onWillPop: () async {
        await playerSesliYoutube.stop();
        return true;
      },
      child: GestureDetector(
        onDoubleTap: () async {
          playerSesliYoutube.playing ? await playerSesliYoutube.stop() : null;
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
              onEnded: (metaData) => setState(() {
                controller.updateValue(YoutubePlayerValue(isPlaying: false));
              }),
              controller: controller,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.white,
              ),
            ),
            builder: (context, player) => Scaffold(
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: player),
                        ),
                        SizedBox(
                          height: 70.h,
                        ),
                        Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            shadows: const [
                              BoxShadow(
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  color: Colors.black)
                            ],
                            size: 100,
                            color: Colors.white)
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
