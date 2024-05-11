import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';

class DetailScreenProvider extends ChangeNotifier {
  String? views;
  final box = Hive.box("favourites");
  bool isGetViewsCalled = false;
  int elapsedTime = 0;
  VoidCallback videoListener(controller, id, dataDetailScreen) {
    return () async {
      if (controller.value.isPlaying && !isGetViewsCalled) {
        isGetViewsCalled = true;
      await apiClient.postViewIncrement(id);
        notifyListeners();
      }
    };
  }

  Future<void> addFavourite(item) async {
    int count = 0;
    for (int key in box.keys) {
      if (key >= count) {
        count = key + 1;
      }
    }
    box.put(count, item);
    notifyListeners();
  }

  Future<void> deleteFavourite(item) async {
    final keys = box.keys;
    final key = keys.firstWhere(
      (e) => box.get(e) == item,
      orElse: () => null,
    );
    if (key != null) {
      box.delete(key);
      for (int k in keys) {
        if (k > key) {
          box.put(k - 1, box.get(k));
          box.delete(k);
        }
      }
      notifyListeners();
    }
  }

  String formatDateTime(dateTimeString, String locale) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final dateTime = inputFormat.parse(dateTimeString);

    final outputFormat = DateFormat("dd MMMM y", locale);
    final formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }
}
