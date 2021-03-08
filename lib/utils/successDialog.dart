import 'package:finder/values/dialog.dart';
import 'package:finder/values/theme.dart';
import 'package:flutter/cupertino.dart';

import 'buttons.dart';

void showSuccessDialog(BuildContext context) {
  showDialog<String>(
      context: context,
      builder: (BuildContext buildcontext) {
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