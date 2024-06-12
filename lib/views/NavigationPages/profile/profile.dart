import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/utils/nav_util.dart';
import 'package:wallpaper/utils/utils.dart';
import 'package:wallpaper/views/NavigationPages/profile/liked_images.dart';
import 'package:wallpaper/widgets/custom_input_field.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool editModeOn = false;
  final userNameCtrl = TextEditingController();
  final userNameNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ab = Provider.of<AuthenticationBloc>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                (ab.profileImage.trim() != "")
                    ? Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              ab.profileImage,
                            ),
                            radius: 40,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xff3B4071),
                              radius: 15,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              "assets/images/auth.png",
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: const Color(0xff3B4071),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                const SizedBox(
                  width: 20,
                ),
                editModeOn
                    ? SizedBox(
                        height: 100,
                        width: size.width - 180,
                        child: buildInputFieldThemeColor(
                          "UserName",
                          null,
                          TextInputType.name,
                          userNameCtrl,
                          context,
                          true,
                          userNameNode,
                          null,
                          editModeOn,
                          false,
                          GestureDetector(
                            onTap: () async {
                              if (userNameCtrl.text.isEmpty) {
                                showSnackBar(context, 'Username should not be empty.');
                                return;
                              }
                              await ab.updateUserName(userNameCtrl.text);
                              setState(() {
                                editModeOn = false;
                              });
                            },
                            child: const Icon(
                              Icons.save,
                              color: Color(0xff3B4071),
                            ),
                          ),
                          20,
                          Colors.white,
                          (value) {
                            return null;
                          },
                        ),
                      )
                    : Text(
                        ab.userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3B4071),
                        ),
                      ),
                const Spacer(),
                Visibility(
                  visible: !editModeOn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        editModeOn = true;
                      });
                    },
                    child: Image.asset(
                      "assets/images/edit.png",
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            getProfileItem(CupertinoIcons.heart_fill, "Liked Wallpaper", () {
              push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LikedImages(),
                ),
              );
            }),
            const SizedBox(
              height: 30,
            ),
            getProfileItem(Icons.settings, "Account Settings", null),
            const SizedBox(
              height: 30,
            ),
            getProfileItem(Icons.language, "Language Settings", null),
            const SizedBox(
              height: 30,
            ),
            getProfileItem(Icons.question_answer, "FAQ", null),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                ab.logOut(context);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getProfileItem(
    IconData icon,
    String title,
    Function? onPress,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xff3B4071),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff3B4071),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            if (onPress != null) {
              onPress();
            }
          },
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}
