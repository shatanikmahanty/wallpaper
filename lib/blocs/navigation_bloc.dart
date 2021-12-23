import 'package:flutter/cupertino.dart';
import 'package:wallpaper/models/NavItemModel.dart';

class NavigationBloc extends ChangeNotifier {
  final List<NavItemModel> _bottomNavigationBarItem = [
    NavItemModel("Menu", CupertinoIcons.square_grid_2x2_fill),
    NavItemModel("Downloads", CupertinoIcons.download_circle_fill),
    NavItemModel("Profile", CupertinoIcons.person_alt_circle_fill),
  ];

  List<NavItemModel> get bottomNavigationBarItem => _bottomNavigationBarItem;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int index){
    _currentIndex = index;
    notifyListeners();
  }

}
