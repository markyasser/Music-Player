import 'package:flutter/material.dart';
import 'package:music_player/app_router.dart';
import 'package:music_player/constants/strings.dart';

void main() {
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            // color: Color.fromARGB(255, 255, 203, 112),
            ),
        // This is the theme of your application.
        primarySwatch: Colors.amber,
        // fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        primaryColorDark: Colors.black,
        primaryColor: Colors.black,
        dialogBackgroundColor: Colors.black,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: homePageRoute,
    );
  }
}
