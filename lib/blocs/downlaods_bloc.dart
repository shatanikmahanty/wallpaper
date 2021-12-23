import 'package:flutter/foundation.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

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
}
