import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timerg/providers/data_provider.dart';
import 'package:timerg/screens/time_picker_screen.dart';
import 'package:timerg/screens/login_screens/auth_screen.dart';
import 'package:timerg/screens/projects_screen.dart';
import 'firebase_options.dart';
import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "TimerGeo",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (context) => const AuthScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        SetProjectScreen.routeName: (context) => SetProjectScreen(),
        ProjectScreen.routeName: (context) => ProjectScreen(),
        TimePickerScreen.routeName: (context) => TimePickerScreen()
        // PinPositionScreen.routeName: (context) => PinPositionScreen,

        // SearchScreen.routeName: (context) => SearchScreen(),
      },
    );
  }
}
