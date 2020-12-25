import 'package:firebase_database/firebase_database.dart';

class FirebaseCntrl {
  List<String> wordList = new List();
  var databaseReference = FirebaseDatabase.instance.reference();

  List<String> getLvl1Data() {
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, String> values = snapshot.value;
      values.forEach((key, values) {
        wordList.add(values[key]);
      });

    });
    return wordList;
  }
}
