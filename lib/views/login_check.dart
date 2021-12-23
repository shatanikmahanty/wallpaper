//Redirection class based on login check
import 'package:flutter/material.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/views/flutter_splash.dart';
import 'package:wallpaper/views/NavigationPages/home/home_screen.dart';
import 'package:wallpaper/views/navigation/bottomNavigationScaffold.dart';

class LoginCheckPage extends StatelessWidget {
  const LoginCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context);

    return FutureBuilder(
        future: ab.getUserDataFromSharedPrefs(),
        builder: (context, snap) {
          return snap.data == null
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                )
              : snap.data == true
                  ? const BottomNavigationScaffold()
                  : const FlutterSplash();
        });
  }
}
