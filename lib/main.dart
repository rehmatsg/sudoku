import 'package:flutter/material.dart';
import 'package:sudoku/screens/landing.dart';
import 'package:sudoku/theme/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {

  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.build(brightness: Brightness.light),
      // darkTheme: AppTheme.build(brightness: Brightness.dark),
      home: LandingPage(),
    );
  }

}