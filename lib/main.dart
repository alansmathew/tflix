import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//width: MediaQuery.of(context).size.width,

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int pass_index, selectedIndex = 0;
int page = 1;
List<dynamic> data1 = [];
List<String> medium_cover = [];
List<String> movie_title = [];
List<int> movie_year = [];

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    setState(() {
      getdata();
      _scrollController = ScrollController()
        ..addListener(() {
//          print("offset = ${_scrollController.position.userScrollDirection}");
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            print(page + 1);
            loadMore();
          }
        });
    });
  }

  Future<String> getdata() async {
    http.Response response = await http.get(
        'https://yts.mx/api/v2/list_movies.json?sort_by=year&order_by=desc');
    List data = jsonDecode(response.body)['data']['movies'];
    for (var i = 0; i < 20; i++) {
      setState(() {
        medium_cover.add(data[i]['medium_cover_image']);
        movie_title.add(data[i]['title']);
        movie_year.add(data[i]['year']);
        data1.add(data[i]);
      });
      print(response);
    }
  }

  Future<String> loadMore() async {
    page++;
    print(page);
    http.Response response = await http.get(
        'https://yts.mx/api/v2/list_movies.json?sort_by=year&order_by=desc&page=$page');
    List data = jsonDecode(response.body)['data']['movies'];
    for (var i = 0; i < 20; i++) {
      setState(() {
        medium_cover.add(data[i]['medium_cover_image']);
        movie_title.add(data[i]['title']);
        movie_year.add(data[i]['year']);
        data1.add(data[i]);
      });
    }
    print('movie titles =${movie_title.length}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  int selectedIndex = 0;
  final widgetOptions = [
    Text('Beer List'),
    Text('Add new beer'),
    Text('Favourites'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: GridView.count(
          controller: _scrollController,
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 20,
          childAspectRatio: (MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height) +
              .123,
          children: List.generate(movie_title.length, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => SpecificMovie(),
                      ),
                    );
                    print(MediaQuery.of(context).size.width);
                    print(MediaQuery.of(context).size.height);
                    pass_index = index;
//                    print(index);
//                    print(data1.runtimeType);
//                    print('container ${data1[index]}');
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 10,
                          blurRadius: 15,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        medium_cover[index],
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                  ),
                ),
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 13,
                      child: Text(
                        movie_title[index],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -18,
                      child: SizedBox(
                        width: 100,
                        height: 15,
                        child: Text(
                          movie_year[index].toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Color.fromRGBO(255, 255, 255, 0),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(
                    color: Colors
                        .white))), // sets the inactive color of the `BottomNavigationBar`
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 9,
                blurRadius: 60,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
//              onTap: onItemTapped(index),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text(''),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text(''),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  title: Text(''),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.folder_open,
                  ),
                  title: Text(''),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

//----------------------------------------- 2nd page -----------------------------------------

class SpecificMovie extends StatefulWidget {
  @override
  _SpecificMovieState createState() => _SpecificMovieState();
}

class _SpecificMovieState extends State<SpecificMovie> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//  print(data1[pass_index]['title']);
  @override
  Widget build(BuildContext context1) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data1[pass_index]['medium_cover_image']),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.3), BlendMode.dstATop),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.0,
                    sigmaY: 2.0,
                  ),
                  child: Scaffold(
                    // Your usual Scaffold for content
                    backgroundColor: Colors.black12,
                    body: Container(),
                  )),
            ),
            Column(
              children: <Widget>[
                SafeArea(
                  child: Row(
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () {
//                        print(data1[pass_index]['large_cover_image']);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 30, bottom: 10),
                          width: MediaQuery.of(context).size.width - 260,
                          height:
                              ((MediaQuery.of(context).size.width - 260) / 2) *
                                  0.85,
                          child: new RawMaterialButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            fillColor: Colors.blue,
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Play',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            //TODO here goes stream magnet and stream url
                            onPressed: () {},
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              width:
                                  (MediaQuery.of(context).size.width - 270) / 2,
                              height:
                                  ((MediaQuery.of(context).size.width - 270) /
                                          2) *
                                      .7,
                              child: new RawMaterialButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                fillColor: Color.fromRGBO(255, 255, 255, 0.2),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '720',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width - 270) / 2,
                              height:
                                  ((MediaQuery.of(context).size.width - 270) /
                                          2) *
                                      .7,
                              child: new RawMaterialButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                fillColor: Color.fromRGBO(255, 255, 255, 0.2),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '1080',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 170,
                      height: 255,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 10,
                            blurRadius: 15,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          data1[pass_index]['medium_cover_image'],
                          height: 170.0,
                          width: 255.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.black,
                          Colors.transparent
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        data1[pass_index]['title'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          fontFamily: 'Font',
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width -
                                          63,
                                      margin: EdgeInsets.only(bottom: 2),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        data1[pass_index]['year'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          fontFamily: 'Font',
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom: 10, right: 15),
                                    ),
                                    Container(
                                      child: Text(
                                        //TODO when there is two genres should display both
                                        data1[pass_index]['genres'][0]
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          fontFamily: 'Font',
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom: 10, right: 15),
                                    ),
                                    Text(
                                      data1[pass_index]['rating'].toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        fontFamily: 'Font',
                                      ),
                                    ),
                                    Text(
                                      '  IMDB',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 189, 10, 1),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        fontFamily: 'Font',
                                      ),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Description',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 10),
                                    ),
                                  ],
                                ),
                                Text(
                                  data1[pass_index]['description_full']
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height: 1.4,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------- video player page --------------------------------

//class videoPlayer extends StatefulWidget {
//  @override
//  _videoPlayerState createState() => _videoPlayerState();
//}
//
//class _videoPlayerState extends State<videoPlayer> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
