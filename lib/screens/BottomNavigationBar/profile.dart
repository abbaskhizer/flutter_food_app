import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/Profile/profile_bloc.dart';


import 'package:foodie/screens/BottomNavigationBar/aboutscreen.dart';

import 'package:foodie/screens/forgotpassword.dart';
import 'package:foodie/screens/login.dart';
import 'package:foodie/screens/orderscreen.dart';

class ProfileScreen extends StatefulWidget {
  static const pagename = '/profileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;

    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(),
      child: Scaffold(body: Center(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case ProfileLoadingState:
                return const CircularProgressIndicator();
              case ProfileLoadedState:
                return Column(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: screenHeight * 0.090,
                            ),
                            SizedBox(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.5,
                              child: Stack(
                                children: [
                                  if ((state as ProfileLoadedState).imageURL != null && (state).imageURL!.isNotEmpty)
                                    CircleAvatar(
                                        radius: screenHeight * 0.1,
                                        // ignore: unnecessary_type_check
                                        backgroundImage: (state is ProfileLoadedState) ? NetworkImage(state.imageURL!) : null),
                                  Positioned(
                                    left: 110,
                                    top: 110,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.red,
                                                  content: const Text(
                                                    'Get Image From ?',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<ProfileBloc>(context).add(GetImageFromGalleryEvent());
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                          'From Gallery',
                                                          style: TextStyle(color: Colors.white),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<ProfileBloc>(context).add(GetImageFromCamaraEvent());
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                          'From Camara',
                                                          style: TextStyle(color: Colors.white),
                                                        ))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 25,
                                            // color: Colors.black,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.040,
                            ),
                            Text(
                              // ignore: unnecessary_type_check
                              (state is ProfileLoadedState) ? state.nameValue : '',
                              style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.060),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 3,
                              child: SizedBox(
                                height: screenHeight * 0.070,
                                width: screenWidth * 0.8,
                                child: Center(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.020,
                                    ),
                                    const Icon(
                                      Icons.person,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.030,
                                    ),
                                    Text(
                                      // ignore: unnecessary_type_check
                                      (state is ProfileLoadedState) ? state.emailValue : '',
                                      style: TextStyle(fontSize: screenWidth * 0.050),
                                    )
                                  ],
                                )),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.030,
                            ),
                            Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(AboutScreen.pagename);
                                },
                                child: SizedBox(
                                  height: screenHeight * 0.070,
                                  width: screenWidth * 0.8,
                                  child: Center(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.020,
                                      ),
                                      const Icon(Icons.question_mark),
                                      SizedBox(
                                        width: screenWidth * 0.030,
                                      ),
                                      Text(
                                        'About',
                                        style: TextStyle(fontSize: screenWidth * 0.050),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.030,
                            ),
                            Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(OrderScreen.pagename);
                                },
                                child: SizedBox(
                                  height: screenHeight * 0.070,
                                  width: screenWidth * 0.8,
                                  child: Center(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.020,
                                      ),
                                      const Icon(Icons.shopping_bag),
                                      SizedBox(
                                        width: screenWidth * 0.030,
                                      ),
                                      Text(
                                        'My Order',
                                        style: TextStyle(fontSize: screenWidth * 0.050),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.030,
                            ),
                            Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pushNamed(ForgotPasswordScreen.pagename),
                                child: SizedBox(
                                  height: screenHeight * 0.070,
                                  width: screenWidth * 0.8,
                                  child: Center(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.020,
                                      ),
                                      const Icon(Icons.lock),
                                      SizedBox(
                                        width: screenWidth * 0.030,
                                      ),
                                      Text(
                                        'Reset Password',
                                        style: TextStyle(fontSize: screenWidth * 0.050),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.030,
                            ),
                            Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        backgroundColor: Colors.red,
                                        content: const Text(
                                          'Do you want to Logout ?',
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.white),
                                              )),
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pushReplacementNamed(LoginScreen.pagename),
                                              child: const Text(
                                                'Logout',
                                                style: TextStyle(color: Colors.white),
                                              )),
                                        ]),
                                  );
                                },
                                child: SizedBox(
                                  height: screenHeight * 0.070,
                                  width: screenWidth * 0.8,
                                  child: Center(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.020,
                                      ),
                                      const Icon(Icons.logout),
                                      SizedBox(
                                        width: screenWidth * 0.030,
                                      ),
                                      Text(
                                        'Logout',
                                        style: TextStyle(fontSize: screenWidth * 0.050),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                );

              default:
                return const CircularProgressIndicator(
                  color: Colors.red,
                );
            }
          },
        ),
      )),
    );
  }
}
