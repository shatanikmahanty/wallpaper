import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaper/configs/configs.dart';
import 'package:wallpaper/views/NavigationPages/home/home_screen.dart';
import 'package:wallpaper/utils/nav_util.dart';
import 'package:wallpaper/utils/utils.dart';
import 'package:wallpaper/views/auth/login.dart';
import 'package:wallpaper/views/navigation/bottomNavigationScaffold.dart';

class AuthenticationBloc extends ChangeNotifier {
  bool _registrationSuccess = false;
  bool _registrationStarted = false;
  bool _loginSuccess = false;
  bool _loginStarted = false;
  bool _isLoggedIn = false;

  bool get registrationSuccess => _registrationSuccess;

  bool get registrationStarted => _registrationStarted;

  bool get loginSuccess => _loginSuccess;

  bool get loginStarted => _loginStarted;

  bool get isLoggedIn => _isLoggedIn;

  String _email = '';
  String _userId = '';
  String _userName = '';
  String _profileImage = '';

  String get email => _email;

  String get userId => _userId;

  String get userName => _userName;

  String get profileImage => _profileImage;

  AuthenticationBloc() {
    getUserDataFromSharedPrefs();
  }

  void register(String email, String password, BuildContext context) async {
    User? user;

    _registrationStarted = true;
    notifyListeners();

    try {
      user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    if (user != null) {
      saveNewUserDataToFirebase(user).onError((error, stackTrace) {
        showSnackBar(context, 'Unexpected error occurred, please try again');
        _registrationStarted = false;
      }).then((value) async {
        await saveToSharedPreferences(user: user!).onError((error, stackTrace) {
          showSnackBar(context, 'Unexpected error occurred, please try again');
          _registrationStarted = false;
        }).then((value) async {
          _registrationSuccess = true;
          _registrationStarted = false;
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 1500), () {
            _registrationSuccess = false;
            notifyListeners();
          });
          pushAndRemoveAll(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const BottomNavigationScaffold();
              },
            ),
          );
        });
      });

      notifyListeners();
    } else {
      showSnackBar(context, 'Invalid server response, please try again');
      _registrationStarted = false;
    }
  }

  void login(String email, String password, BuildContext context) async {
    User? user;

    _loginStarted = true;
    notifyListeners();

    try {
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    if (user != null) {
      getUserDataFromFirebase(user).onError((error, stackTrace) {
        showSnackBar(context, 'Unexpected error occurred, please try again');
        _registrationStarted = false;
      }).then((value) async {
        Map<String, dynamic> userMap = {
          "email": value!['email'],
          "uid": value['uid'],
          "userName": value['userName'],
          "profilePic":
              value.containsKey('profilePic') ? value['profilePic'] : "",
        };

        await saveToSharedPreferences(map: userMap)
            .onError((error, stackTrace) {
          showSnackBar(context, 'Unexpected error occurred, please try again');
          _loginStarted = false;
        }).then((value) async {
          _loginStarted = false;
          _loginSuccess = true;
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 1500), () {
            _loginSuccess = false;
            notifyListeners();
          });
          pushAndRemoveAll(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const BottomNavigationScaffold();
              },
            ),
          );
        });
      });
    } else {
      showSnackBar(context, 'Invalid server response, please try again');
      _loginStarted = false;
    }
    notifyListeners();
  }

  Future saveToSharedPreferences(
      {User? user, Map<String, dynamic>? map}) async {
    if (user != null) {
      _userId = user.uid;
      _email = user.email ?? "";
      _userName = (user.email ?? "").split("@")[0];
    } else if (map != null) {
      _userId = map['uid'];
      _email = map['email'];
      _userName = map['userName'];
      _profileImage = map['profilePic'];
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(Configs.prefLoginStatus, true);
    pref.setString(Configs.prefEmail, email);
    pref.setString(Configs.prefUID, userId);
    pref.setString(Configs.prefUserName, userName);
    pref.setString(Configs.prefProfilePic, _profileImage);
  }

  Future saveNewUserDataToFirebase(User user) async {
    await FirebaseFirestore.instance
        .collection(Configs.users)
        .doc(user.uid)
        .set({
      "uid": user.uid,
      "email": user.email ?? "",
      "userName": (user.email ?? "").split("@")[0],
    });
  }

  Future<Map<String, dynamic>?> getUserDataFromFirebase(User user) async {
    DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore
        .instance
        .collection(Configs.users)
        .doc(user.uid)
        .get();

    return docRef.data();
  }

  Future getUserDataFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _email = pref.getString(Configs.prefEmail) ?? "";
    _userId = pref.getString(Configs.prefUID) ?? "";
    _userName = pref.getString(Configs.prefUserName) ?? "";
    _isLoggedIn = pref.getBool(Configs.prefLoginStatus) ?? false;
    notifyListeners();
    return _isLoggedIn;
  }

  Future logOut(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    _email = "";
    _userId = "";
    _userName = "";
    _isLoggedIn = false;
    await FirebaseAuth.instance.signOut();
    pushAndRemoveAll(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future updateUserName(String name) async {
    await FirebaseFirestore.instance
        .collection(Configs.users)
        .doc(userId)
        .update({
      "userName": name,
    });
    _userName = name;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Configs.prefUserName, userName);
    notifyListeners();
  }
}
