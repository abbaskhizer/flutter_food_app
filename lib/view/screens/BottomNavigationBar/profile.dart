
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/Profile/profile_bloc.dart';

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

    return BlocProvider(
      create: (context) => ProfileBloc(context),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is ProfileLoadedState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header Section
                      SizedBox(
                        height: screenHeight * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: screenHeight * 0.090),
                            SizedBox(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.5,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: screenHeight * 0.1,
                                    backgroundImage: state.imageURL != null && state.imageURL!.isNotEmpty
                                        ? NetworkImage(state.imageURL!)
                                        :null
                                  ),
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
                                                elevation: 3,
                                                title: const Text(
                                                  'Get Image From ?',
                                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(dialogContext).pop();
                                                      BlocProvider.of<ProfileBloc>(context).add(GetImageFromCamaraEvent());
                                                    },
                                                    child: const Text(
                                                      'Camera',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(dialogContext).pop();
                                                      BlocProvider.of<ProfileBloc>(context).add(GetImageFromGalleryEvent());
                                                    },
                                                    child: const Text(
                                                      'Gallery',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 25),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.040),
                            Text(
                              state.nameValue,
                              style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.060),
                            ),
                          ],
                        ),
                      ),
                      // Options List Section
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  height: 70,
                                  width: screenWidth * 0.8,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.020),
                                      const Icon(Icons.person),
                                      SizedBox(width: screenWidth * 0.030),
                                      Text(state.emailValue, style: TextStyle(fontSize: screenWidth * 0.050)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<ProfileBloc>(context).add(AboutEvent());
                                },
                                child: SizedBox(
                                  height: 70,
                                  width: screenWidth * 0.8,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.020),
                                      const Icon(Icons.question_mark),
                                      SizedBox(width: screenWidth * 0.030),
                                      Text('About', style: TextStyle(fontSize: screenWidth * 0.050)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<ProfileBloc>(context).add(MyOrderEvent());
                                },
                                child: SizedBox(
                                  height: 70,
                                  width: screenWidth * 0.8,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.020),
                                      const Icon(Icons.shopping_bag),
                                      SizedBox(width: screenWidth * 0.030),
                                      Text('My Order', style: TextStyle(fontSize: screenWidth * 0.050)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<ProfileBloc>(context).add(ResetPasswordtEvent());
                                },
                                child: SizedBox(
                                  height: 70,
                                  width: screenWidth * 0.8,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.020),
                                      const Icon(Icons.lock),
                                      SizedBox(width: screenWidth * 0.030),
                                      Text('Reset Password', style: TextStyle(fontSize: screenWidth * 0.050)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Material(
                              elevation: 3,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      backgroundColor: Colors.red,
                                      content: const Text(
                                        'Do you want to Logout?',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                            BlocProvider.of<ProfileBloc>(context).add(CancelDialogEvent());
                                          },
                                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                            BlocProvider.of<ProfileBloc>(context).add(LogOutDialogEvent());
                                          },
                                          child: const Text('Logout', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 70,
                                  width: screenWidth * 0.8,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.020),
                                      const Icon(Icons.logout),
                                      SizedBox(width: screenWidth * 0.030),
                                      Text('Logout', style: TextStyle(fontSize: screenWidth * 0.050)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator(color: Colors.red));
              }
            },
          ),
        ),
      ),
    );
  }
}
