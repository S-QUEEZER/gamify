import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/login/signin.dart';
import 'package:halenest/onboarding/intro.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/screens/navBar.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1); //if already shown -> 1 else 0
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: ((context, child) {
          return MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
            child: MaterialApp(
              title: 'Halenest',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                // splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                primarySwatch: Colors.blue,
              ),
              initialRoute:
                  initScreen == 0 || initScreen == null ? 'onboard' : 'home',
              routes: {
                'home': (context) => StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            return const ButtonNavBar();
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.error}'),
                            );
                          }
                        }

                        // means connection to future hasnt been made yet
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return const SignInScreen();
                      },
                    ),
                'onboard': (context) => const IntroScreen(),
              },
            ),
          );
        }));
  }
}
