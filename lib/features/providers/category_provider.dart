import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  int indexItem1 = 0;
  final player = AudioPlayer();
  final playerBack = AudioPlayer();
  final playerInitState = AudioPlayer();

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
    List array = [
      UrlSource(audio),
      // AppSounds.navinfo,
      UrlSource(items[indexItem1].audio),
    ];

    for (var item in array) {
      if (item is String) {
        await playerInitState.play(AssetSource(item));
      } else if (item is UrlSource) {
        await playerInitState.play(item);
      }
      await playerInitState.onPlayerComplete.first;
    }
  }

  onPopSounds(items, categoryAudio) async {
    List<UrlSource> sources = [
      UrlSource(categoryAudio),
      UrlSource(items[indexItem1].audio)
    ];

    for (var item in sources) {
      await playerBack.play(item);
      await playerBack.onPlayerComplete.first;
    }
  }

  itemsNameSounds(items) async {
    try {
      final audio = items[indexItem1].audio;
      await playerInitState.stop();
      await playerBack.stop();
      await player.stop();
      await player.play(UrlSource(audio));
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
