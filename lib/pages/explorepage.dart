import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/wallpaper_view_screen.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var images = [
    "https://images.pexels.com/photos/775483/pexels-photo-775483.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3326103/pexels-photo-3326103.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1927314/pexels-photo-1927314.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/2085376/pexels-photo-2085376.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3377538/pexels-photo-3377538.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3381028/pexels-photo-3381028.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3389722/pexels-photo-3389722.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
  ];

  final  _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                  top: 5,
                  left: 20,
                  bottom: 20,
                ),
                child: Text(
                  "Explore",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              StreamBuilder(
                stream: _db
                    .collection("wallpapers")
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      itemCount: snapshot.data!.docs.length,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WallpaperViewPage(
                                          data: snapshot
                                              .data!.docs[index],
                                        )));
                          },
                          child: Hero(
                            tag: snapshot.data!.docs[index].get("wallpaperUrl"),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // child: Image(
                              //   image: NetworkImage(images[index]),
                              // ),
                              child: CachedNetworkImage(
                                placeholder: (ctx, url) => Image(
                                  image: AssetImage("assets/placeholder.jpg"),
                                ),
                                imageUrl:
                                    snapshot.data!.docs[index].get("wallpaperUrl"),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return SpinKitChasingDots(
                    color: primaryColor,
                    size: 50,
                  );
                },
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ));
  }
}