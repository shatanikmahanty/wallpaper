import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/blocs/navigation_bloc.dart';
import 'package:wallpaper/views/NavigationPages/home/home_screen.dart';
import 'package:wallpaper/views/NavigationPages/profile/profile.dart';
import 'package:wallpaper/views/single_image/downloaded_images.dart';

class BottomNavigationScaffold extends StatefulWidget {
  const BottomNavigationScaffold({Key? key}) : super(key: key);

  @override
  _BottomNavigationScaffoldState createState() =>
      _BottomNavigationScaffoldState();
}

class _BottomNavigationScaffoldState extends State<BottomNavigationScaffold> {
  @override
  Widget build(BuildContext context) {
    NavigationBloc nb = Provider.of<NavigationBloc>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 80, 15, 0),
        child: getPage(nb.currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xff3B4071),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        currentIndex: nb.currentIndex,
        items: nb.bottomNavigationBarItem.map((e) {
          return BottomNavigationBarItem(
            icon: Icon(
              e.icon,
              size: 30,
            ),
            label: e.title,
          );
        }).toList(),
        onTap: (index) {
          nb.updateIndex(index);
        },
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const DownloadedImages();
      case 2:
        return const Profile();
      default:
        return const Text("Unimplemented");
    }
  }
}
