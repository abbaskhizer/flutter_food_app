import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/BottomNavigationBar/bottom_navigation_bar_bloc.dart';
import 'package:foodie/screens/BottomNavigationBar/favoritesscreen.dart';
import 'package:foodie/screens/BottomNavigationBar/home.dart';
import 'package:foodie/screens/BottomNavigationBar/menu.dart';
import 'package:foodie/screens/BottomNavigationBar/profile.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const pagename = '/homeScreen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavigationBarBloc, BottomNavigationBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 3,
            showUnselectedLabels: true,
            items: bottomNavItems,
            currentIndex: state.tabIndex,
            selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
            onTap: (index) {
              BlocProvider.of<BottomNavigationBarBloc>(context)
                  .add(TabChange(tabIndex: index));
            },
          ),
        );
      },
    );
  }
}

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.restaurant_menu),
    label: 'Menu',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_outline),
    label: 'Favourite',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
  ),
];

const List<Widget> bottomNavScreen = <Widget>[
  HomeBarScreen(),
  MenuScreen(),
  FavoritesScreen(),
  ProfileScreen(),
];
