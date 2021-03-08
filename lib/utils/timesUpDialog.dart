import 'package:finder/values/dialog.dart';
import 'package:finder/values/theme.dart';
import 'package:flutter/cupertino.dart';

import 'buttons.dart';

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
          content: Text('Süren Doldu :( Baştan başlamak ister misin?'),
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