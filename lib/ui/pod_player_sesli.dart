// ignore_for_file: deprecated_member_use, duplicate_ignore, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodPlayerSesli extends StatefulWidget {
  const PodPlayerSesli({super.key, required this.id});
  final int id;

  @override
  State<PodPlayerSesli> createState() => _PodPlayerSesliState();
}

class _PodPlayerSesliState extends State<PodPlayerSesli> {
  late Items dataDetailScreen;
  final playerSesliPod = AudioPlayer();
  late final PodPlayerController controller;

  @override
  void initState() {
    final providerOnBoarding = context.read<OnBoardingProvider>();
    final providerDetailScreen = context.read<DetailScreenProvider>();
    playAudio();
    // providerDetailScreen.isGetViewsCalled = false;
    dataDetailScreen = providerOnBoarding.allLessons!
        .firstWhere((item) => item.id == widget.id, orElse: () => null);
    // providerDetailScreen.getVimeoVideoData(int.parse(dataDetailScreen.link!));

    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(
          dataDetailScreen.link.toString(),
        ),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
        ))
      ..initialise();
    providerDetailScreen.postViews(dataDetailScreen.id);
    playerSesliPod.playerStateStream.listen((event) {
      event.processingState == ProcessingState.completed
          ? setState(() {
              controller.play();
            })
          : null;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      playerSesliPod.stop();
    }
  }

  void playAudio() async {
    await playerSesliPod.setAsset(AppSounds.navinfovideo);
    await playerSesliPod.play();
  }

  @override
  Widget build(BuildContext context) {
    context.read<DetailScreenProvider>();
    final providerOnBoarding = context.read<OnBoardingProvider>();
    return WillPopScope(
      onWillPop: () async {
        await playerSesliPod.stop();
        return true;
      },
      child: GestureDetector(
          onDoubleTap: () async {
            playerSesliPod.playing ? await playerSesliPod.stop() : null;
            setState(() {
              controller.isVideoPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          onHorizontalDragEnd: (details) => details.primaryVelocity! > 0
              ? controller.videoSeekForward(const Duration(seconds: 10))
              : controller.videoSeekBackward(const Duration(seconds: 10)),
          onVerticalDragEnd: (details) async {
            details.primaryVelocity! > 0
                ? [await playerSesliPod.stop(), Navigator.pop(context, true)]
                : null;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IgnorePointer(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child:
                            // WebViewWidget(
                            // controller: providerDetailScreen.controllerWebView),

                            PodVideoPlayer(
                          controller: controller,
                          videoThumbnail: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              dataDetailScreen.image != null
                                  ? providerOnBoarding.linkStart +
                                      dataDetailScreen.image.toString()
                                  : providerOnBoarding.imageError,
                            ),
                          ),
                          alwaysShowProgressBar: false,
                        )),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  Icon(
                      controller.isVideoPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      shadows: const [
                        BoxShadow(
                            spreadRadius: 3, blurRadius: 5, color: Colors.black)
                      ],
                      size: 100,
                      color: Colors.white)
                ],
              ),
            ),
          )),
    );
  }
}

// class YoutubePlayerSesli extends StatefulWidget {
//   final int id;
//   const YoutubePlayerSesli({required this.id, super.key});
//   @override
//   State<YoutubePlayerSesli> createState() => _YoutubePlayerSesliState();
// }

// class _YoutubePlayerSesliState extends State<YoutubePlayerSesli>
//     with WidgetsBindingObserver {
//   late Items dataDetailScreen;
//   final playerSesliYoutube = AudioPlayer();
//   late YoutubePlayerController controller;
//   @override
//   void initState() {
//     final providerOnBoarding = context.read<OnBoardingProvider>();
//     final providerDetailScreen = context.read<DetailScreenProvider>();
//     WidgetsBinding.instance.addObserver(this);
//     playAudio();
//     providerDetailScreen.isGetViewsCalled = false;
//     dataDetailScreen = providerOnBoarding.allLessons!
//         .firstWhere((item) => item.id == widget.id, orElse: () => null);
//     controller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(dataDetailScreen.link!)!,
//       flags: const YoutubePlayerFlags(
//           autoPlay: false, hideControls: true, disableDragSeek: true),
//     );
//     playerSesliYoutube.playerStateStream.listen((event) {
//       event.processingState == ProcessingState.completed
//           ? controller.play()
//           : null;
//     });

//     controller.addListener(() {
//       providerDetailScreen.videoListener(
//           controller, dataDetailScreen.id, dataDetailScreen);
//       if (mounted) setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (!mounted) return;
//     if (state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.paused) {
//       playerSesliYoutube.stop();
//     }
//   }

//   void playAudio() async {
//     await playerSesliYoutube.setAsset(AppSounds.navinfovideo);
//     await playerSesliYoutube.play();
//   }

//   @override
//   void deactivate() {
//     controller.pause();
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await playerSesliYoutube.stop();
//         return true;
//       },
//       child: GestureDetector(
//         onDoubleTap: () async {
//           playerSesliYoutube.playing ? await playerSesliYoutube.stop() : null;
//           controller.value.isPlaying ? controller.pause() : controller.play();
//         },
//         onHorizontalDragEnd: (details) => details.primaryVelocity! > 0
//             ? controller.seekTo(
//                 Duration(seconds: controller.value.position.inSeconds + 10))
//             : controller.seekTo(
//                 Duration(seconds: controller.value.position.inSeconds - 10)),
//         onVerticalDragEnd: (details) async {
//           details.primaryVelocity! > 0
//               // ignore: use_build_context_synchronously
//               ? [await playerSesliYoutube.stop(), Navigator.pop(context, true)]
//               : null;
//         },
//         child: YoutubePlayerBuilder(
//             player: YoutubePlayer(
//               onEnded: (metaData) => setState(() {
//                 controller.updateValue(YoutubePlayerValue(isPlaying: false));
//               }),
//               controller: controller,
//               progressColors: const ProgressBarColors(
//                 playedColor: Colors.red,
//                 handleColor: Colors.white,
//               ),
//             ),
//             builder: (context, player) => Scaffold(
//                   backgroundColor: Colors.white,
//                   body: Padding(
//                     padding: EdgeInsets.all(16.r),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8.r),
//                               child: player),
//                         ),
//                         SizedBox(
//                           height: 70.h,
//                         ),
//                         Icon(
//                             controller.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow,
//                             shadows: const [
//                               BoxShadow(
//                                   spreadRadius: 3,
//                                   blurRadius: 5,
//                                   color: Colors.black)
//                             ],
//                             size: 100,
//                             color: Colors.white)
//                       ],
//                     ),
//                   ),
//                 )),
//       ),
//     );
//   }
// }
