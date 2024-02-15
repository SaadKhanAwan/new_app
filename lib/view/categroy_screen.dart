import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categoryNewModel.dart';
import 'package:news_app/view_Model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedvalue = "General";
  final formate = DateFormat('MMM dd yyyy');

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedvalue = categoriesList[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Card(
                            color: selectedvalue == categoriesList[index]
                                ? Colors.blue
                                : Colors.grey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                  child: Text(
                                categoriesList[index].toString(),
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 15, color: Colors.white)),
                              )),
                            )),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: FutureBuilder<CategoryNewsModel>(
                future: NewsViewModel().fetchCategoryNewsApi(selectedvalue),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinkit);
                  } else if (snapshot.data == null ||
                      snapshot.data!.articles == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "No Data!!! Check Your Connection",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                        GestureDetector(
                          onTap: () {
                            _refresh();
                          },
                          child: Text(
                            "Click Here to Refresh",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
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
