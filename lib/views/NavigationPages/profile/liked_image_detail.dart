import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikedImageDetail extends StatefulWidget {
  final String url;

  const LikedImageDetail({Key? key, required this.url}) : super(key: key);

  @override
  _LikedImageDetailState createState() => _LikedImageDetailState();
}

class _LikedImageDetailState extends State<LikedImageDetail> {
  bool moreViewEnabled = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              tag: widget.url,
              child: AnimatedContainer(
                width: size.width,
                height: moreViewEnabled ? size.height * 3 / 4 : size.height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.url,
                    fit: BoxFit.cover,
                  ),
                ),
                duration: const Duration(milliseconds: 800),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            top: moreViewEnabled ? size.height * 3 / 4 : size.height,
            left: 0,
            height: size.height / 4,
            child: Container(
              height: size.height / 4,
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
                            onPressed: () {},
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
                            onPressed: () {},
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
