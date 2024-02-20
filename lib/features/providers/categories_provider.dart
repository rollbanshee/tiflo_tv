import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoriesProvider extends ChangeNotifier {
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

  initStateCategoriesSounds(categories) async {
    List array = [
      AppSounds.categories,
      AppSounds.navinfo,
      UrlSource(categories[indexItem1].audio),
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

  onPopSounds(categories) async {
    List sources = [
      AppSounds.categories,
      UrlSource(categories[indexItem1].audio),
    ];

    for (var item in sources) {
      if (item is String) {
        await playerBack.play(AssetSource(item));
      } else if (item is UrlSource) {
        await playerBack.play(item);
      }
      await playerBack.onPlayerComplete.first;
    }
  }

  itemsNameSounds(categories) async {
    try {
      final audio = categories[indexItem1].audio;
      await playerInitState.stop();
      await playerBack.stop();
      await player.stop();
      await player.play(UrlSource(audio));
    } catch (e) {
      e;
    }
  }
}
