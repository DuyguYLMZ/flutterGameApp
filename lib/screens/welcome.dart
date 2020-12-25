import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:finder/values/dialog.dart' show UnicornAlertDialog;
import 'package:finder/values/firebasecontroller.dart';
import 'package:finder/values/strings.dart';
import 'package:finder/values/theme.dart';
import 'package:finder/values/words_enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../pageprovider.dart';

class Welcome extends StatefulWidget {
  final int seconds;
  final VoidCallback onFinish;
  final TextStyle textStyle;

  // Welcome({this.seconds = 180, this.onFinish, this.textStyle});
  Welcome({this.seconds = 20, this.onFinish, this.textStyle});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {

  AssetsAudioPlayer _assetsAudioPlayer;
  FirebaseCntrl firebaseCntrl = new FirebaseCntrl();
  List<int> selectedNumberList = new List<int>();
  List<String> wordsList = new List<String>();
  List<bool> switched = new List<bool>();
  List<String> newList = List<String>();
  BuildContext _context;
  int _i = 0;
  int scoreValue;
  AnimationController _controller;
  var provider;
  String get timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(
      Audio("assets/audio/Concerto.mp3"),
      autoStart: true,
    );
    _assetsAudioPlayer.playOrPause();
    _controller = AnimationController(
        duration: Duration(seconds: widget.seconds), vsync: this);
    for (var w in Words) {
      newList.add(w.toString());
      wordsList.add(w.toString());
    }
    _controller.addListener(() {
      if (timerString != null && timerString == "0:00") {
        showTimesUPDialog(context);
        _controller.dispose();
      }
    });
    _controller.reverse(from: 1.0);
    newList = _getCardName(newList);
  }

  void dispose() {
    _controller.dispose();
    //  _assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _firebaseRef = FirebaseDatabase().reference().child('level1');
    provider = Provider.of<PageProvider>(context);
    scoreValue = provider.score;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[cyan, pink])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          slivers: <Widget>[
            StreamBuilder(
              stream: _firebaseRef.onValue,
              builder: (context,  snap)
              {
                if(snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null){
                  Map data = snap.data.snapshot.value;
                  List item = [];
                  data.forEach((index, data) => item.add({"key": index, ...data}));
                  Column(
                    children: <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        floating: false,
                        pinned: true,
                        primary: true,
                        bottom: PreferredSize(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text("Score : " + scoreValue.toString(),
                                      style: TextStyle(color: white))),
                              Row(
                                children: [
                                  Container(
                                      child: Text("Timer : ",
                                          style: TextStyle(color: white))),
                                  AnimatedBuilder(
                                      animation: _controller,
                                      builder: (BuildContext context, Widget child) {
                                        return Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: 12.0, color: Colors.white),
                                        );
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                        expandedHeight: 120,
                        title: Text(Strings.BUNEOLA + " ?"),
                        centerTitle: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(_scramble(wordsList[_i])),
                          background: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        delegate:
                        SliverChildBuilderDelegate((BuildContext context, int index) {
                          this._context = context;
                          switched.add(false);
                          Color cardColor = Color(Random().nextInt(0xffffffff));
                          String cardName = newList[index];
                          return listItem(
                              cardColor, cardName.toString(), index, _context);
                        }, childCount: newList.length),
                      )
                    ],
                  );
                }

              },

            )
          ],
        ),
      ),
    );
  }

  Widget listItem(
      Color color, String cardName, int index, BuildContext _context) =>
      InkWell(
        onTap: () {
          if (cardName == wordsList[_i]) {
            if (_i == wordsList.length) {
              showSuccessDialog();
            } else if (!switched[index]) {
              setState(() {
                scoreValue = provider.scoreValue(scoreValue++);
                _i = provider.getWordsIndex();
                switched[index] = true;
              });
            }
          }
        },
        child: Card(
          color: color,
          child: AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  ScaleTransition(
                    child: child,
                    scale: animation,
                  ),
              child: _animatedWidget(color, index, cardName)),
        ),
      );

  void showSuccessDialog() {
    showDialog<String>(
        context: _context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: new Text("hellooo"),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Text("heey."),
              ),
            ],
          );
        });
  }

  void showTimesUPDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UnicornAlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Tüh !'),
            titleTextStyle: textStyle,
            content: Text('Süren Doldu :('),
            contentTextStyle: whiteTextFormStyle,
            gradient: LinearGradient(
              colors: [cyan, pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          );
        });
  }

  _animatedWidget(Color color, int index, String colorName) {
    return switched[index] != null && switched[index]
        ? Container(
      key: ValueKey(1),
      color: color,
    )
        : Container(
      key: ValueKey(2),
      child: Text(
        colorName,
        style:
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _scramble(String wordsList) {
    List<String> letter = List<String>();
    String newWord = "";
    var rnd = new Random();
    wordsList.runes.forEach((int rune) {
      letter.add(new String.fromCharCode(rune));
    });
    for (int i = 0; i < letter.length; i++) {
      int j = rnd.nextInt(letter.length);
      var x = letter[i];
      letter[i] = letter[j];
      letter[j] = x;
    }
    for (var l in letter) {
      newWord += l;
    }
    return newWord;
  }

  List<String> _getCardName(List<String> wordsList) {
    var random = new Random();
    for (var i = wordsList.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = wordsList[i];
      wordsList[i] = wordsList[n];
      wordsList[n] = temp;
    }

    return wordsList;
  }
}
