import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:wallpaper/blocs/unsplash_bloc.dart';
import 'package:wallpaper/utils/nav_util.dart';
import 'package:wallpaper/views/single_image/image_detail.dart';

class SingleTopicTabView extends StatefulWidget {
  final String topicId;

  const SingleTopicTabView({Key? key, required this.topicId}) : super(key: key);

  @override
  _SingleTopicTabViewState createState() => _SingleTopicTabViewState();
}

class _SingleTopicTabViewState extends State<SingleTopicTabView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      UnsplashBloc ub = Provider.of<UnsplashBloc>(context, listen: false);
      if (ub.photosPerTopic.containsKey(widget.topicId) ||
          (ub.photosPerTopic[widget.topicId] ?? []).isEmpty) {
        ub.getImageForTopic(widget.topicId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UnsplashBloc ub = Provider.of<UnsplashBloc>(context);

    return (ub.photosPerTopic[widget.topicId] == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ((ub.photosPerTopic[widget.topicId] ?? []).isEmpty)
            ? const Center(
                child: Text("No wallpapers found for this topic"),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: StaggeredGridView.countBuilder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  crossAxisCount: 4,
                  itemCount: ub.photosPerTopic[widget.topicId]?.length,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (BuildContext context, int index) {
                    Photo photo = ub.photosPerTopic[widget.topicId]![index];
                    return InkWell(
                      onTap: () {
                        push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ImageDetail(photo: photo);
                            },
                          ),
                        );
                      },
                      child: Hero(
                        tag: photo.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: photo.urls.regular.toString(),
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
              );
  }
}
