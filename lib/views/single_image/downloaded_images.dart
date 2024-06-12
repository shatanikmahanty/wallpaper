import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/blocs/downloads_bloc.dart';
import 'package:wallpaper/utils/nav_util.dart';
import 'package:wallpaper/views/single_image/downloaded_image_detail.dart';

class DownloadedImages extends StatefulWidget {
  const DownloadedImages({Key? key}) : super(key: key);

  @override
  _DownloadedImagesState createState() => _DownloadedImagesState();
}

class _DownloadedImagesState extends State<DownloadedImages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context, listen: false);

      DownloadsBloc db = Provider.of<DownloadsBloc>(context, listen: false);
      await db.listFiles(ab.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    DownloadsBloc db = Provider.of<DownloadsBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              "Downloaded Images",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        if (db.downloadedImagesPaths.isEmpty) const Spacer(),
        (db.isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : db.downloadedImagesPaths.isEmpty
                ? const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_off_sharp,
                          size: 50,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "No downloaded images found",
                          style: TextStyle(fontSize: 20, color: Color(0xff3B4071), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                      crossAxisCount: 4,
                      itemCount: db.downloadedImagesPaths.length,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DownloadedImageDetail(
                                    filePath: db.downloadedImagesPaths[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: db.downloadedImagesPaths[index],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                io.File(db.downloadedImagesPaths[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    ),
                  ),
        if (db.downloadedImagesPaths.isEmpty) const Spacer(),
      ],
    );
  }
}
