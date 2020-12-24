import 'package:blog_app/photoupload.dart';
//import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Posts.dart';
import 'package:flutter/gestures.dart';
//import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
//import 'package:flutter';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];
  final ScrollController controller = ScrollController();
  bool isPlaying = false;
  FlutterTts _flutterTts;
  FlutterTts _flut; //////////
  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
    _flut.stop(); /////
  }

  //void _logoutUser() {}
  @override
  void initState() {
    super.initState();
    initializeTts();
    initializeFlut(); ////
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA = snap.value;
      postList.clear();
      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['desc'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );
        postList.add(posts);
      }
      setState(() {
        print('length : $postList.length');
      });
    });
  }

  initializeTts() {
    _flutterTts = FlutterTts();

    if (Platform.isAndroid) {
      _flutterTts.ttsInitHandler(() {
        setTtsLanguage();
      });
    } else if (Platform.isIOS) {
      setTtsLanguage();
    }

    _flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  initializeFlut() {
    //////////////////
    _flut = FlutterTts();

    if (Platform.isAndroid) {
      _flut.ttsInitHandler(() {
        setFlutTtsLanguage();
      });
    } else if (Platform.isIOS) {
      setFlutTtsLanguage();
    }

    _flut.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    _flut.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    _flut.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  void setFlutTtsLanguage() async {
    await _flutterTts.setLanguage("hi"); //hi-IN
  }

  Future _speaker(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flut.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stopper() async {
    var result = await _flut.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }
  /////////////////

  ////////////////////
  Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  void setTtsLanguage() async {
    await _flutterTts.setLanguage("en-US"); //hi-IN
  }

  /*void speechSettings1() {
    _flutterTts.setVoice("en-us-x-sfg#male_1-local");
    _flutterTts.setPitch(1);
    _flutterTts.setSpeechRate(.9);
  }
  void speechSettings2() {
    _flutterTts.setVoice("en-us-x-sfg#male_2-local");
    _flutterTts.setPitch(1);
    _flutterTts.setSpeechRate(.9);
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        //bacolor: Colors.
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
        backgroundColor: Colors.pink[300],
        shadowColor: Colors.black,
        //new Column(children: [],),
        title: Text(
          " Translation",
          textAlign: TextAlign.center,
        ),
      ),
      body: new DraggableScrollbar(
        heightScrollThumb: 40.0,
        controller: controller,
        child: postList.length == 0
            ? new Text("No Posts are Available")
            : new ListView.builder(
                scrollDirection: Axis.vertical,
                controller: controller,
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return postsUI(
                      postList[index].image,
                      postList[index].description,
                      postList[index].desc,
                      postList[index].date,
                      postList[index].time);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.perm_identity),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new UploadPhotoPage();
          }));
        },
      ),
    );
  }

  Widget postsUI(
      String image, String description, String desc, String date, String time) {
    return new Card(
        //shape: ShapeBorder. ,
        //borderRadius: BorderRadius.
        //shadow: Shadow,
        color: Colors.pink[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        elevation: 10.0,
        margin: EdgeInsets.all(15.0),
        child: new Container(
          padding: new EdgeInsets.all(14.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    time,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              new Image.network(
                image,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.pink[300],
                thickness: 1.0,
              ),
              new Text(
                description,
                style: Theme.of(context).textTheme.subtitle1, //subhead
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6.0,
              ),
              new Column(
                //: Alignment.ce,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Alignment: Alignment.centre,
                  new FlatButton(
                      onPressed: () {
                        setState(() {
                          isPlaying ? _stop() : _speak(description);
                        });
                      },
                      child: isPlaying
                          ? Icon(
                              Icons.volume_up,
                              size: 40,
                              color: Colors.redAccent,
                            )
                          : Icon(
                              Icons.volume_off,
                              size: 40,
                              color: Colors.redAccent,
                            ))
                ],
              ),
              Divider(
                color: Colors.pink[300],
                thickness: 1.0,
              ),
              new Text(
                desc,
                style: Theme.of(context).textTheme.subtitle1, //subhead
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6.0,
              ),
              new Column(
                //: Alignment.ce,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Alignment: Alignment.centre,
                  new FlatButton(
                      onPressed: () {
                        setState(() {
                          isPlaying ? _stopper() : _speaker(desc);
                        });
                      },
                      child: isPlaying
                          ? Icon(
                              Icons.volume_up,
                              size: 40,
                              color: Colors.redAccent,
                            )
                          : Icon(Icons.volume_off,
                              size: 40, color: Colors.redAccent)),
                ],
              ),
            ],
          ),
        ));
  }
}

class DraggableScrollbar extends StatefulWidget {
  final double heightScrollThumb;
  final Widget child;
  final ScrollController controller;

  DraggableScrollbar({this.heightScrollThumb, this.child, this.controller});

  @override
  _DraggableScrollbarState createState() => new _DraggableScrollbarState();
}

class _DraggableScrollbarState extends State<DraggableScrollbar> {
  //this counts offset for scroll thumb in Vertical axis
  double _barOffset;
  //this counts offset for list in Vertical axis
  double _viewOffset;
  @override
  void initState() {
    super.initState();
    _barOffset = 0.0;
    _viewOffset = 0.0;
  }

  //if list takes 300.0 pixels of height on screen and scrollthumb height is 40.0
  //then max bar offset is 260.0
  double get barMaxScrollExtent =>
      context.size.height - widget.heightScrollThumb;
  double get barMinScrollExtent => 0.0;

  //this is usually lenght (in pixels) of list
  //if list has 1000 items of 100.0 pixels each, maxScrollExtent is 100,000.0 pixels
  double get viewMaxScrollExtent => widget.controller.position.maxScrollExtent;
  //this is usually 0.0
  double get viewMinScrollExtent => widget.controller.position.minScrollExtent;

  double getScrollViewDelta(
    double barDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    //propotion
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _barOffset += details.delta.dy;

      if (_barOffset < barMinScrollExtent) {
        _barOffset = barMinScrollExtent;
      }
      if (_barOffset > barMaxScrollExtent) {
        _barOffset = barMaxScrollExtent;
      }

      double viewDelta = getScrollViewDelta(
          details.delta.dy, barMaxScrollExtent, viewMaxScrollExtent);

      _viewOffset = widget.controller.position.pixels + viewDelta;
      if (_viewOffset < widget.controller.position.minScrollExtent) {
        _viewOffset = widget.controller.position.minScrollExtent;
      }
      if (_viewOffset > viewMaxScrollExtent) {
        _viewOffset = viewMaxScrollExtent;
      }
      widget.controller.jumpTo(_viewOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      widget.child,
      GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          child: Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: _barOffset),
              child: _buildScrollThumb())),
    ]);
  }

  Widget _buildScrollThumb() {
    return new Container(
      
      height: widget.heightScrollThumb,
      width: 20.0,
      
      color: Colors.redAccent,
    );
  }
}
