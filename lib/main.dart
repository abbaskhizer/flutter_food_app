import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodie/controller/bloc/BottomNavigationBar/bottom_navigation_bar_bloc.dart';

import 'package:foodie/controller/internetController.dart';

import 'package:foodie/controller/routes/routes.dart';

import 'package:foodie/view/screens/splashScreen.dart';
import 'package:get/get.dart';

// @pragma('vm:entry-point')

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
}

Future<void> main() async{
 WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // if (kIsWeb) {
  //     await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyBBbf8WzwshzMKcMD8VVwSu1vsDuezp_uE",
  // authDomain: "foodie-5bc9b.firebaseapp.com",
  // projectId: "foodie-5bc9b",
  // storageBucket: "foodie-5bc9b.appspot.com",
  // messagingSenderId: "126684678629",
  // appId: "1:126684678629:web:b64c47152b7ad94d03070c",
  // measurementId: "G-W1CEM16KEP"));
    
  // }else{
  //   await Firebase.initializeApp();
  // }

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
//    FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
// await firebaseAppCheck.activate();

  Stripe.publishableKey = 'pk_test_51NSeUcBFkokQNkwsKsTgJiJRI6RzKbIZ2JasRFWmQfCYbJ8gk5KPmihLImHmjA5Zb8S3Wj1VxQY4ngyhXty1rebD00gNy07Cyk';

  await FirebaseMessaging.instance.getInitialMessage();

 

  Get.put(InternetController(), permanent: true);

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
  Widget build(BuildContext context) {
    return ProviderScope(
      child: BlocProvider(
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
}
