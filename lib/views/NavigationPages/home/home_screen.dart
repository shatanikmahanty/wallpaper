import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/blocs/auth_bloc.dart';
import 'package:wallpaper/blocs/unsplash_bloc.dart';
import 'package:wallpaper/views/NavigationPages/home/tab/tab_topic.dart';
import 'package:wallpaper/widgets/custom_input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<UnsplashBloc>(context, listen: false)
          .getTopics(context, this);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context);
    UnsplashBloc ub = Provider.of<UnsplashBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello,",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff3B4071),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  ab.userName + "  👋",
                  style: const TextStyle(
                    color: Color(0xff3B4071),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                ab.logOut(context);
              },
              icon: const Icon(
                Icons.logout,
                size: 35,
                color: Color(0xff3B4071),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        buildInputFieldThemeColor(
          "Search Wallpaper",
          null,
          TextInputType.text,
          _searchCtrl,
          context,
          true,
          _searchNode,
          null,
          true,
          false,
          getSearchButton(),
          40,
          const Color(0xfff3f3f3),
          searchValidate,
        ),
        if (ub.topics == null || ub.topicsTabController == null)
          const Expanded(child: Center(child: CircularProgressIndicator())),
        if (ub.topics != null && ub.topicsTabController != null) ...[
          const SizedBox(
            height: 30,
          ),
          TabBar(
            indicator: BoxDecoration(
              color: const Color(
                0xff3b4071,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: List.generate(
              ub.topics?.length ?? 0,
              (index) => Tab(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    (ub.topics ?? [])[index].title,
                    // style: const TextStyle(
                    //   color: Color(0xffAAAAAA),
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                ),
              ),
            ),
            controller: ub.topicsTabController,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
              children: List.generate(
                ub.topics?.length ?? 0,
                (index) => SingleTopicTabView(topicId: ub.topics![index].id),
              ),
              controller: ub.topicsTabController,
            ),
          ),
        ]
      ],
    );
  }

  String? searchValidate(String? value) {
    return null;
  }

  GestureDetector getSearchButton() {
    return GestureDetector(
      onTap: () {
        ///TODO
      },
      child: const Icon(
        Icons.search,
        color: Color(0xff3B4071),
        size: 30,
      ),
    );
  }
}
