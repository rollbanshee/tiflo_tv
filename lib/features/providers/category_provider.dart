// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoryProvider extends ChangeNotifier {
  int indexItem1 = 0;
  final player = AudioPlayer();
  ScrollController controller = ScrollController();
  onSwipe(String swipe, int length) {
    if (swipe == "+") {
      indexItem1 >= length ? indexItem1 = 0 : indexItem1++;
    } else if (swipe == "-") {
      indexItem1 <= 0 ? indexItem1 = length : indexItem1--;
    }
    notifyListeners();
  }

  initStateCategorySounds(items, audio) async {
    final playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(Uri.parse(audio)),
        items.isEmpty
            ? AudioSource.asset(AppSounds.emptyback)
            : AudioSource.uri(Uri.parse(items[indexItem1].audio)),
      ],
    );
    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      print("$e /////////////////////////////////////////////");
    }
  }

  onPopSounds(items, categoryAudio) async {
    final playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(categoryAudio)),
      AudioSource.uri(Uri.parse(items[indexItem1].audio))
    ]);

    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      print("$e /////////////////////////////////////////////");
    }
  }

  itemsNameSounds(items) async {
    try {
      final audio = items[indexItem1].audio;
      await player.stop();
      await player.setUrl(audio);
      await player.play();
    } catch (e) {
      print(e);
    }
  }
}
