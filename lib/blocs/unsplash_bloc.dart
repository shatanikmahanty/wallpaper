import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';

class UnsplashBloc extends ChangeNotifier {
  UnsplashClient? _client;
  List<Topic>? _topics;
  TabController? _topicsTabController;

  TabController? get topicsTabController => _topicsTabController;

  List<Topic>? get topics => _topics;
  Map<String, List<Photo>?> _photosPerTopic = {};

  Map<String, List<Photo>?> get photosPerTopic => _photosPerTopic;

  Future getTopics(BuildContext context, TickerProvider vsync) async {
    if (_client == null) {
      initClient();
    }
    _topics = await _client?.topics.list(idsOrSlugs: [""]).goAndGet();
    if (_topics == null) {
      _topics = [];
      return;
    }
    _topicsTabController =
        TabController(length: _topics?.length ?? 0, vsync: vsync);
    notifyListeners();
  }

  Future<void> getImageForTopic(String topicId) async {
    if (topics != null) {
      List<Photo>? photos = await _client?.topics.photos(topicId).goAndGet();
      _photosPerTopic.putIfAbsent(topicId, () => photos);
      notifyListeners();
    }
  }

  initClient() {
    _client = UnsplashClient(
      settings: const ClientSettings(
        credentials: AppCredentials(
          accessKey: "xpLCnBd-dpb52trEVYNO0euZ_s1XQKMMT7npNChQhQw",
          secretKey: "I2kfHFiyeq1UfYr7AqqPVTRJZ3CZvLfbAJSp6YhQk38",
        ),
      ),
    );
  }
}
