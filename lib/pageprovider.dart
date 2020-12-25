import 'package:flutter/cupertino.dart';

class PageProvider extends ChangeNotifier {
  List<Color> _cardColor = new List<Color>();
  List<String> wordsList = new List<String>();
  int _wordsIndex = 0;
  int _score = 0;

  void addColor(Color color) {
    _cardColor = new List<Color>();
    _cardColor.add(color);
    notifyListeners();
  }

  List<Color> getColor() {
    return _cardColor;
  }

  int getWordsIndex() {
      _wordsIndex++;
    return _wordsIndex;
  }

  int get score => _score;

  void scoreValue(int value) {
    _score++;
    notifyListeners();
  }
}
