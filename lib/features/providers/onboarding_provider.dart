import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class OnBoardingProvider extends ChangeNotifier {
  int sliding = 1;
  final player = AudioPlayer();
  List<dynamic> items = [];
  List? data = [];
  bool isLoading = false;
  Future<void> getDataOnboarding(context, manager) async {
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
      await manager.emptyCache();
      data = await apiClient.getData();
      items = data!.map((e) => e.items).expand((items) => items).toList();
      isLoading = false;
      Navigator.pop(context);
      notifyListeners();
    }
  }

  initStateOnBoardingSounds() async {
    List array = [AppSounds.welcome, AppSounds.entertocategories];
    await player.play(AssetSource(array[0]));
    int i = 1;
    player.onPlayerComplete.listen((_) async {
      if (i < array.length) {
        await player.play(AssetSource(array[i]));
        i++;
      }
    });
  }

  Future<void> getData() async {
    if (!isLoading) {
      isLoading = true;
      data = await apiClient.getData();
      items = data!.map((e) => e.items).expand((items) => items).toList();
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
