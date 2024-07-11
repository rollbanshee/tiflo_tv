import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';

class DetailScreenProvider extends ChangeNotifier {
  final box = Hive.box("favourites");
  // bool isGetViewsCalled = false;
  int elapsedTime = 0;
  String? views;
  // String? vimeoHTML;
  // String? vimeoEmbedURL;
  // WebViewController controllerWebView = WebViewController();
  // Future<void> getVimeoVideoData(id) async {
  //   final responseData = await apiClient.getVimeoVideoData(id);
  //   vimeoHTML = responseData['embed']['html'];
  //   vimeoEmbedURL = responseData['player_embed_url'];
  //   final html = '''
  //           <html>
  //             <head>
  //               <style>
  //                 body {
  //                  background-color: lightgray;
  //                  margin: 0px;
  //                  }
  //                  iframe {
  //                           display: block;
  //                           background: #000;
  //                           border: none;
  //                           height: 100vh;
  //                           width: 100vw;
  //                       }
  //               </style>
  //               <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
  //               <meta http-equiv="Content-Security-Policy"
  //               content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *;
  //               img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
  //            </head>
  //            <body>
  //               $vimeoHTML
  //            </body>
  //           </html>
  //           ''';
  //   controllerWebView
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..loadHtmlString(html);
  //   notifyListeners();
  // }

  Future<void> postViews(id) async {
    views = null;
    views = await apiClient.postViewIncrement(id);
    notifyListeners();
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
