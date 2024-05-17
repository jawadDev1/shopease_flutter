import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shopeease/screens/home.dart';
import 'package:shopeease/screens/store.dart';
import 'package:shopeease/screens/profile.dart';

import 'package:shopeease/utils/theme.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentScreen;

  late HomeScreen home;
  late Store store;
  late ProfileScreen profile;

  @override
  void initState() {
    home = HomeScreen();
    store = Store();
    profile = ProfileScreen();
    pages = [home, store, profile];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: AppTheme.background,
        color: AppTheme.primary,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 28.0,
          ),
          Icon(
            Icons.store,
            color: Colors.white,
            size: 28.0,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
            size: 28.0,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
