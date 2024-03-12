import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

DefaultCacheManager manager = DefaultCacheManager();

class OnBoardingProvider extends ChangeNotifier {
  int sliding = 1;
  final player = AudioPlayer();
  List<dynamic> items = [];
  List data = [];
  List audio = [];
  String dataVersion = "";
  // SharedPreferences? prefs;
  bool isLoading = false;

  Future<void> getDataOnboarding(context) async {
    if (!isLoading) {
      isLoading = true;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Platform.isAndroid
                ? Center(
                    child: SizedBox(
                    height: 32.h,
                    width: 32.w,
                    child: const CircularProgressIndicator(
                        strokeWidth: 3, color: Colors.white),
                  ))
                : Center(
                    child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15.r,
                  ));
          });
      // prefs = await SharedPreferences.getInstance();
      dataVersion = await apiClient.getUpdateVersion();
      data = await apiClient.getData();
      items = data.map((e) => e.items).expand((items) => items).toList();
      audio.clear();
      // ignore: avoid_function_literals_in_foreach_calls
      items.forEach((e) => audio.add(e.audio));
      data.forEach(((e) => audio.add(e.audio)));
      Uint8List dataVersionUint8 = Uint8List.fromList(dataVersion.codeUnits);
      FileInfo? fileInfo = await manager.getFileFromCache("version.txt");
      final cachedVersion = fileInfo?.file.readAsStringSync();
      if (cachedVersion != dataVersion) {
        // await prefs!.setString("version", dataVersion);
        await manager.emptyCache();
        await manager.putFile("version.txt", dataVersionUint8);
        await Future.wait(
            audio.map((audioUrl) => manager.downloadFile(audioUrl)));
      }
      isLoading = false;
      Navigator.pop(context);
      notifyListeners();
    }
  }

  initStateOnBoardingSounds() async {
    final playlist = ConcatenatingAudioSource(children: [
      AudioSource.asset(AppSounds.welcome),
      AudioSource.asset(AppSounds.entertocategories),
    ]);
    await player.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
    await player.play();
  }

  Future<void> getData() async {
    if (!isLoading) {
      isLoading = true;
      data = await apiClient.getData();
      items = data.map((e) => e.items).expand((items) => items).toList();
      isLoading = false;
      notifyListeners();
    }
  }

  onValueChanged(value) {
    sliding = value!;
    notifyListeners();
  }

  onSwipe(value) {
    sliding = value!;
    notifyListeners();
  }
}
