import 'package:finder/pageprovider.dart';
import 'package:finder/screens/splash.dart';
import 'package:finder/screens/welcome.dart';
import 'package:finder/values/strings.dart';
import 'package:finder/values/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => PageProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
}
  @override
  Widget build(BuildContext context) {

    var assetsImage = new AssetImage(
        'assets/images/ikon.png'); //<- Creates an object that fetches an image.
    var image = new Image(image: assetsImage);
    return new SplashScreen(
        seconds: 4,
        image: image,
        title: new Text(Strings.BUNEOLA, style: textStyle),
        navigateAfterSeconds: Welcome(),
        gradientBackground: new LinearGradient(
            colors: [pink, cyan],
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: MediaQuery
            .of(context)
            .size
            .height / 6,
        loaderColor: white);
  }
}
