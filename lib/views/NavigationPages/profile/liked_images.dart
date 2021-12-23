import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/blocs/liked_images_bloc.dart';
import 'package:wallpaper/utils/nav_util.dart';
import 'package:wallpaper/views/NavigationPages/profile/liked_image_detail.dart';

class LikedImages extends StatefulWidget {
  const LikedImages({Key? key}) : super(key: key);

  @override
  _LikedImagesState createState() => _LikedImagesState();
}

class _LikedImagesState extends State<LikedImages> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      LikedImagesBloc lib =
          Provider.of<LikedImagesBloc>(context, listen: false);
      if (lib.likedImages.isEmpty) {
        lib.getLikedImages(context.read<AuthenticationBloc>().userId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LikedImagesBloc lib = Provider.of<LikedImagesBloc>(context);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "Liked Images",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        if (lib.likedImages.isEmpty) const Spacer(),
        (lib.isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : lib.likedImages.isEmpty
                ? Center(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.cloud_off_sharp,
                          size: 50,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "No Liked images found",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff3B4071),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 8),
                      crossAxisCount: 4,
                      itemCount: lib.likedImages.length,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LikedImageDetail(
                                    url: lib.likedImages[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: lib.likedImages[index],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: lib.likedImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 2 : 1),
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    ),
                  ),
        if (lib.likedImages.isEmpty) const Spacer(),
      ],
    ));
  }
}
