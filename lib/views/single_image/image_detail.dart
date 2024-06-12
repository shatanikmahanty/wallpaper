import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/blocs/downloads_bloc.dart';
import 'package:wallpaper/blocs/liked_images_bloc.dart';
import 'package:wallpaper/utils/utils.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ImageDetail extends StatefulWidget {
  final Photo photo;

  const ImageDetail({Key? key, required this.photo}) : super(key: key);

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  bool moreViewEnabled = false;

  DateFormat format = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LikedImagesBloc lib = Provider.of<LikedImagesBloc>(context);

    AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context);
    DownloadsBloc db = Provider.of<DownloadsBloc>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
          ),
          Positioned(
            top: 0,
            child: Hero(
              tag: widget.photo.id,
              child: AnimatedContainer(
                width: size.width,
                height: moreViewEnabled ? size.height * 2 / 3 : size.height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.photo.urls.regular.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                duration: const Duration(milliseconds: 800),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            top: moreViewEnabled ? size.height * 2 / 3 : size.height,
            left: 0,
            height: size.height / 3,
            child: Container(
              height: size.height / 3,
              width: size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 15, 25, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            moreViewEnabled = false;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_downward,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.photo.description ?? "No title found",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3b4071),
                      ),
                    ),
                    if (widget.photo.tags != null) ...[
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        widget.photo.tags.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3b4071),
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      widget.photo.source!["alt_description"] ?? "No description found",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      format.format(widget.photo.updatedAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width / 2 - 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color(0xff3b4071),
                                ),
                              ),
                            ),
                            onPressed: () {
                              db.downloadImage(widget.photo.urls.regular, widget.photo.id, ab.userId, context);
                            },
                            child: const Text(
                              "Download",
                              style: TextStyle(
                                color: Color(0xff3b4071),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2 - 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              backgroundColor: const Color(0xff3b4071),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              int location =
                                  WallpaperManager.HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
                              String result;
                              var file =
                                  await DefaultCacheManager().getSingleFile(widget.photo.urls.regular.toString());
                              try {
                                result = await WallpaperManager.setWallpaperFromFile(
                                  file.path,
                                  location,
                                );
                              } on PlatformException {
                                result = 'Failed to get wallpaper.';
                              }
                              showSnackBar(context, result);
                            },
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: size.height * 2 / 3 - 40,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: moreViewEnabled ? 1 : 0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 10,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    onPressed: () {
                      String url = widget.photo.urls.regular.toString();
                      if (lib.likedImages.contains(url)) {
                        lib.removeLike(ab.userId, url);
                      } else {
                        lib.addNewLike(ab.userId, url);
                      }
                    },
                    icon: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Icon(
                        lib.likedImages.contains(widget.photo.urls.regular.toString())
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !moreViewEnabled,
            child: Positioned(
              bottom: 80,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width / 7,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    moreViewEnabled = true;
                  });
                },
                child: const Text(
                  "More",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
