import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper/utils/utils.dart';

class DownloadsBloc extends ChangeNotifier {
  String? directory;
  List<String> _downloadedImagesPaths = [];
  bool _isLoading = true;

  List<String> get downloadedImagesPaths => _downloadedImagesPaths;

  bool get isLoading => _isLoading;

  Future listFiles(String uid) async {
    _isLoading = true;
    notifyListeners();
    directory = (await getApplicationDocumentsDirectory()).path;

    try {
      _downloadedImagesPaths = io.Directory("$directory/downloads/$uid/")
          .listSync()
          .map((item) => item.path)
          .where((item) {
        String lowerItem = item.toLowerCase();
        if (lowerItem.endsWith(".jpg") ||
            lowerItem.endsWith("png") ||
            lowerItem.endsWith("jpeg")) {
          return true;
        } else {
          return false;
        }
      }).toList();
    } on io.FileSystemException catch (e) {
      _downloadedImagesPaths = [];
      if (kDebugMode) {
        print(e.osError?.errorCode);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  downloadImage(Uri url, String photoId, String uid,BuildContext context) async {
    showSnackBar(context, "Download Started");
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/downloads/$uid";
    String filePathAndName =
        documentDirectory.path + '/downloads/$uid/$photoId.png';

    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);

    showSnackBar(context, "Download Complete");
    listFiles(uid);
  }
}
