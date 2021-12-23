import 'package:flutter/material.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/views/auth/login.dart';
import 'package:wallpaper/utils/nav_util.dart';
import 'package:wallpaper/utils/utils.dart';
import 'package:wallpaper/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;

  TextEditingController emailCtrl = TextEditingController(),
      passCtrl = TextEditingController(),
      confirmPassCtrl = TextEditingController();

  FocusNode emailNode = FocusNode(),
      passNode = FocusNode(),
      confirmPassNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context);

    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Wallpaper",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "Beautiful Photos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
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
                height: 20,
              ),
              SizedBox(
                width: size.width - 60,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      buildInputFieldThemeColor(
                        "Email",
                        Icons.person,
                        TextInputType.emailAddress,
                        emailCtrl,
                        context,
                        false,
                        emailNode,
                        passNode,
                        !ab.registrationStarted,
                        false,
                        const SizedBox(),
                        12,
                        Colors.white,
                        (value) {
                          if ((value?.trim() ?? '').isEmpty) {
                            return 'Email cannot be empty';
                          }

                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value?.trim() ?? '');
                          if (emailValid) {
                            return null;
                          } else {
                            return 'Invalid Email';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      buildInputFieldThemeColor(
                        "Password",
                        Icons.person,
                        TextInputType.visiblePassword,
                        passCtrl,
                        context,
                        false,
                        passNode,
                        confirmPassNode,
                        !ab.registrationStarted,
                        obscure,
                        getObscureToggleButton(),
                        12,
                        Colors.white,
                        (value) {
                          if ((value?.trim() ?? '').length < 6) {
                            return 'Password must be at least 6 characters long';
                          }

                          bool passValid = RegExp(
                                  r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                              .hasMatch(value?.trim() ?? '');
                          if (passValid) {
                            return null;
                          } else {
                            return 'Password must contain at least one character,one number and one special character';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      buildInputFieldThemeColor(
                        "Confirm Password",
                        Icons.person,
                        TextInputType.visiblePassword,
                        confirmPassCtrl,
                        context,
                        true,
                        confirmPassNode,
                        null,
                        !ab.registrationStarted,
                        obscure,
                        getObscureToggleButton(),
                        12,
                        Colors.white,
                        (value) {
                          if (value == passCtrl.text) {
                            return null;
                          } else {
                            return 'Both passwords must be same';
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // pushReplacement((
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const SignUpPage(),
                    //   ),
                    // );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
                    if (ab.registrationStarted) {
                      showSnackBar(
                          context, "Please wait, registration underway");
                    } else {
                      if (_formKey.currentState!.validate()) {
                        ab.register(emailCtrl.text.trim(), passCtrl.text.trim(),
                            context);
                      }
                    }
                  },
                  child: ab.registrationSuccess
                      ? const Icon(
                          Icons.done,
                          color: Colors.lightBlueAccent,
                        )
                      : !ab.registrationStarted
                          ? const Text(
                              "Sign Up 📲",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          : const CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                height: 20,
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
                      if (ab.registrationStarted) {
                        showSnackBar(
                            context, "Please wait, registration underway");
                        return;
                      }
                      pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "login Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getObscureToggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          obscure = !obscure;
        });
      },
      child: Icon(
        obscure ? Icons.lock : Icons.lock_open,
        color: Colors.black,
      ),
    );
  }
}
