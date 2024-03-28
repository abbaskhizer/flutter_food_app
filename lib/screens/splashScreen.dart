import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/SplashScreen/splash_screen_cubit.dart';


class SplashScreen extends StatefulWidget {
  static const pagename = '/';

  const SplashScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;



  @override
  void initState() {
    super.initState();
  
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;

    return BlocProvider(
      create: (context) => SplashScreenCubit(context),
      child: Scaffold(
        body: BlocBuilder<SplashScreenCubit, SplashScreenState>(
          builder: (context, state) {
            return Center(
                child: ScaleTransition(
                    scale: animation,
                    child: Image(
                        height: screenHeight*0.6,
                        width: screenWidth*0.6,
                        image: const AssetImage('assets/images/foodie.png'))));
          },
        ),
      ),
    );
  }
}
