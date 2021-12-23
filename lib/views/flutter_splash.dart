import 'package:flutter/material.dart';
import 'package:wallpaper/views/auth/login.dart';
import 'package:wallpaper/views/auth/sign_up.dart';
import 'package:wallpaper/utils/nav_util.dart';

class FlutterSplash extends StatefulWidget {
  const FlutterSplash({Key? key}) : super(key: key);

  @override
  State<FlutterSplash> createState() => _FlutterSplashState();
}

class _FlutterSplashState extends State<FlutterSplash> {
  bool animationComplete = false;
  bool animationStarted = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await Future.delayed(
          const Duration(
            seconds: 1,
          ), () {
        setState(() {
          animationStarted = true;
        });
      });

      await Future.delayed(
          const Duration(
            seconds: 1,
          ), () {
        setState(() {
          animationComplete = true;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/auth.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              child: const Text(
                "Wallpaper",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.bold),
              ),
              duration: const Duration(milliseconds: 800),
              top: animationStarted ? 40 : size.height / 2 - 80,
              curve: Curves.easeIn,
            ),
            AnimatedPositioned(
              child: const Text(
                "Beautiful Photos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              duration: const Duration(milliseconds: 900),
              top: animationStarted ? 100 : size.height / 2 - 20,
              curve: Curves.easeIn,
            ),
            AnimatedPositioned(
              bottom: 0,
              left: animationComplete ? 0 : size.width + 600,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.bounceInOut,
              child: Column(
                children: [
                  SizedBox(
                    width: size.width - 60,
                    child: const Text(
                      "Explore ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width - 60,
                    child: const Text(
                      "Explore beautiful wallpapers and set them in your devices 😊",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: size.width - 60,
                    height: 70,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      onPressed: () {
                        push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignUpPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up with Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
