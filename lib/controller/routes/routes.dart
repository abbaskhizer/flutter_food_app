import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foodie/controller/bloc/cart/cart_bloc.dart';

import 'package:foodie/controller/bloc/order/order_bloc.dart';
import 'package:foodie/view/screens/BottomNavigationBar/aboutscreen.dart';

import 'package:foodie/view/screens/ErrorScreen.dart';
import 'package:foodie/view/screens/cartscreen.dart';

import 'package:foodie/view/screens/fooddetailscreen.dart';

import 'package:foodie/view/screens/forgotpassword.dart';

import 'package:foodie/view/screens/homeScreen.dart';
import 'package:foodie/view/screens/login.dart';
import 'package:foodie/view/screens/orderscreen.dart';

import 'package:foodie/view/screens/signup.dart';
import 'package:foodie/view/screens/splashScreen.dart';

Route onGenerateRoute(RouteSettings settings) {
  if (settings.name == SplashScreen.pagename) {
    return SlideFadeTransition(
      page: const SplashScreen(),
    );
  } else if (settings.name == LoginScreen.pagename) {
    return SlideFadeTransition(page: const LoginScreen());
  } else if (settings.name == SignUpScreen.pagename) {
    return SlideFadeTransition(
      page: const SignUpScreen(),
      settings: settings,
    );
  } else if (settings.name == HomeScreen.pagename) {
    return SlideSideMoveRoute(
      page: const HomeScreen(),
    );
  } else if (settings.name == ForgotPasswordScreen.pagename) {
    return SlideFadeTransition(
      page: const ForgotPasswordScreen(),
    );
  } else if (settings.name == OrderScreen.pagename) {
    return SlideFadeTransition(
      page: const OrderScreen(),
    );
  } else if (settings.name == FoodDetailScreen.pagename) {
    return SlideBottomRoute(
        page: BlocProvider<CartBloc>(
          create: (context) => CartBloc(context),
          child: const FoodDetailScreen(),
        ),
        settings: settings);
  } else if (settings.name == CartScreen.pagename) {
    return SlideSideMoveRoute(
        page: BlocProvider<CartBloc>(
          create: (context) => CartBloc(context),
          child: const CartScreen(),
        ),
        settings: settings);
  } else if (settings.name == OrderScreen.pagename) {
    return SlideSideMoveRoute(page: BlocProvider<OrderBloc>(create: (context) => OrderBloc(context), child: const OrderScreen()), settings: settings);
  } else if (settings.name == AboutScreen.pagename) {
    return SlideRightRoute(page: const AboutScreen());
  } else {
    return SlideFadeTransition(
      page: const ErrorScreen(),
    );
  }
}

class SlideFadeTransition extends PageRouteBuilder {
  SlideFadeTransition({RouteSettings? settings, required this.page})
      : super(
            pageBuilder: (context, animation, reverseAnimation) => page,
            transitionDuration: const Duration(seconds: 1),
            reverseTransitionDuration: const Duration(seconds: 1),
            settings: settings,
            transitionsBuilder: (context, animation, reverseAnimation, child) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.bounceIn,
                  ),
                  child: child,
                )));
  final Widget page;
}

class SlideTopRoute extends PageRouteBuilder {
  final Widget page;
  SlideTopRoute({RouteSettings? settings, required this.page})
      : super(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, -1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({RouteSettings? settings, required this.page})
      : super(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return page;
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class SlideBottomRoute extends PageRouteBuilder {
  final Widget page;
  SlideBottomRoute({RouteSettings? settings, required this.page})
      : super(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return page;
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
              // transitionDuration:Duration(seconds: 1);
            });
}

class SlideSideMoveRoute extends PageRouteBuilder {
  final Widget page;
  SlideSideMoveRoute({RouteSettings? settings, required this.page})
      : super(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return page;
            },
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              Animation<Offset> custom = Tween<Offset>(begin: const Offset(1.0, 1.0), end: const Offset(0.0, 0.0)).animate(animation);
              return SlideTransition(position: custom, child: child);
            });
}
