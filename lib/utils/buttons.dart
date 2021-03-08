import 'package:finder/pageprovider.dart';
import 'package:finder/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

var provider = Provider.of<PageProvider>(globalKey.currentState.context);
Widget okBtn = FlatButton(
  child: Text("Tamam"),
  onPressed: () {
    provider.increaseLevel();
  },
);
Widget cancelBtn = FlatButton(
  child: Text("İptal"),
  onPressed: () {
    Listener(
      onPointerDown: (v) {
        print('click red');
      },
      child: Container(
        color: Colors.blue,
        width: 100,
        height: 100,
      ),
    );
  },
);
