import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:finder/values/dialog.dart' show UnicornAlertDialog;
import 'package:finder/values/firebasecontroller.dart';
import 'package:finder/values/strings.dart';
import 'package:finder/values/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../pageprovider.dart';

class Welcome extends StatefulWidget {
  final int seconds;
  final VoidCallback onFinish;
  final TextStyle textStyle;
  Welcome({this.seconds = 120, this.onFinish, this.textStyle});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  AssetsAudioPlayer _assetsAudioPlayer;
  List<int> selectedNumberList = new List<int>();
  List<String> wordsList = new List<String>();
  List<bool> switched = new List<bool>();
  List<String> cardWordsList = List<String>();
  BuildContext _context;
  int _i = 0;
  int scoreValue;
  AnimationController _controller;
  var provider;
  var _fref;
  String get timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
     _fref = FirebaseDatabase().reference();
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(
      Audio("assets/audio/Concerto.mp3"),
      autoStart: true,
    );
    _assetsAudioPlayer.playOrPause();
    _controller = AnimationController(
        duration: Duration(seconds: widget.seconds), vsync: this);

    _controller.addListener(() {
      if (timerString != null && timerString == "0:00") {
        showTimesUPDialog(context);
        _controller.dispose();
      }
    });
    _controller.reverse(from: 1.0);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _firebaseWords = _fref.child('Level1');
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
      child: FutureBuilder(
          future: _firebaseWords.once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if( cardWordsList.length == 0 && wordsList.length==0){
                  cardWordsList.clear();
                  wordsList.clear();
                  List<dynamic> values = snapshot.data.value;
                  for (var o in values) {
                    cardWordsList.add(o);
                    wordsList.add(o);
                  }
                  cardWordsList = _getCardName(cardWordsList);
                }
                return CustomScrollView(
                  slivers: [
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
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
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
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        this._context = context;
                        switched.add(false);
                        Color cardColor = Color(Random().nextInt(0xffffffff));
                        String cardName = cardWordsList[index];
                        return listItem(
                            cardColor, cardName.toString(), index, _context);
                      }, childCount: cardWordsList.length),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }

  Widget listItem(
          Color color, String cardName, int index, BuildContext _context) =>
      InkWell(
        onTap: () {
          if (cardName == wordsList[_i]) {
            if ((_i+1) == wordsList.length) {
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
          return UnicornAlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Harikasın !'),
            titleTextStyle: textStyle,
            content: Text('Bütün kelimeleri bildin. Bir sonraki seviyeye geömek ister misin?'),
            actions: [
              okBtn, cancelBtn
            ],
            contentTextStyle: whiteTextFormStyle,
            gradient: LinearGradient(
              colors: [cyan, pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          );
        });
  }
  Widget okBtn = FlatButton(
    child: Text("Tamam"),
    onPressed: () { },
  );
  Widget cancelBtn = FlatButton(
    child: Text("İptal"),
    onPressed: () { },
  );

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
