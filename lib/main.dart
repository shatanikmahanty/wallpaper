import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/blocs/downloads_bloc.dart';
import 'package:wallpaper/blocs/liked_images_bloc.dart';
import 'package:wallpaper/blocs/navigation_bloc.dart';
import 'package:wallpaper/blocs/unsplash_bloc.dart';
import 'package:wallpaper/views/login_check.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        ChangeNotifierProvider<UnsplashBloc>(
          create: (context) => UnsplashBloc(),
        ),
        ChangeNotifierProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        ChangeNotifierProvider<LikedImagesBloc>(
          create: (context) => LikedImagesBloc(),
        ),
        ChangeNotifierProvider<DownloadsBloc>(
          create: (context) => DownloadsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Wallpaper',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.transparent,
          ),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginCheckPage(),
      ),
    );
  }
}
