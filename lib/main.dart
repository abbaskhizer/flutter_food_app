
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:foodie/bloc/BottomNavigationBar/bottom_navigation_bar_bloc.dart';
import 'package:foodie/routes/routes.dart';

import 'package:foodie/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/v6.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey='pk_test_51NSeUcBFkokQNkwsKsTgJiJRI6RzKbIZ2JasRFWmQfCYbJ8gk5KPmihLImHmjA5Zb8S3Wj1VxQY4ngyhXty1rebD00gNy07Cyk';


  await FirebaseMessaging.instance.getInitialMessage();



  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUUId();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: BlocProvider<BottomNavigationBarBloc>(
        create: (context) => BottomNavigationBarBloc(),
        child: MaterialApp(
          initialRoute: SplashScreen.pagename,
          onGenerateRoute: onGenerateRoute,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }

  void getUUId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UuidV6 uuid = const UuidV6();

    String? value = preferences.getString('uuId');

    if (value == null) {
      String userUUID = uuid.generate();
      preferences.setString("uuId", userUUID);
      // print(userUUID);
    }
  }
}
