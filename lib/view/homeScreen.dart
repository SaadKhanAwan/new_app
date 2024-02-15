import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categoryNewModel.dart';
import 'package:news_app/models/headline_model.dart';
import 'package:news_app/view/categroy_screen.dart';
import 'package:news_app/view/news_detailcscren.dart';
import 'package:news_app/view_Model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedvalue = "abc-news";
  final List<String> mylist = ["al-jazeera-english", "bbc-news", "abc-news"];

  @override
  Widget build(BuildContext context) {
    final formate = DateFormat('MMM dd yyyy');
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (context) {
                return mylist.map((String value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList();
              },
              onSelected: (value) {
                setState(() {
                  selectedvalue = value;
                });
              },
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const CategoryScreen())));
            },
            icon: Image.asset(
              "images/category_icon.png",
              height: 30,
              width: 30,
            ),
          ),
          centerTitle: true,
          title: Text(
            "News",
            style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: height * .5,
              width: width,
              child: FutureBuilder<NewsChannelHeadLineModel>(
                future:
                    NewsViewModel().fetchNewsChannelHeadlineApi(selectedvalue),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinkit);
                  } else if (snapshot.data == null ||
                      snapshot.data!.articles == null) {
                    return Center(
                      child: Text(
                        "No Data !!! Check Your Connection",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 25,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          final datetime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                            image: snapshot.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            author: snapshot
                                                .data!.articles![index].author
                                                .toString(),
                                            newdate: snapshot.data!
                                                .articles![index].publishedAt
                                                .toString(),
                                            title: snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            descreintion: snapshot.data!
                                                .articles![index].description
                                                .toString(),
                                            source: snapshot.data!
                                                .articles![index].source!.name
                                                .toString(),
                                            content: snapshot
                                                .data!.articles![index].content
                                                .toString(),
                                          )));
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * 0.01),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => spinkit,
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      alignment: Alignment.bottomCenter,
                                      height: height * .22,
                                      width: width * 0.7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  formate.format(datetime),
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<CategoryNewsModel>(
                future: NewsViewModel().fetchCategoryNewsApi("General"),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinkit);
                  } else if (snapshot.data == null ||
                      snapshot.data!.articles == null) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          _refresh();
                        },
                        child: Text(
                          "Click here to Refresh",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500)),
                        ),
                      )),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          final datetime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15.0,
                              left: 5,
                            ),
                            child: Row(
                              children: [
                                if (snapshot
                                        .data!.articles![index].urlToImage !=
                                    null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: height * 0.18,
                                      width: width * 0.3,
                                      placeholder: (context, url) => spinkit,
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width: width * .03,
                                ),
                                Expanded(
                                    child: SizedBox(
                                  height: height * .18,
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700)),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Text(
                                              formate.format(datetime),
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final spinkit = const SpinKitCircle(
    color: Colors.blue,
    size: 50,
  );
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }
}
