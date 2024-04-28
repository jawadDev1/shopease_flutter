import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shopeease/screens/home.dart';
import 'package:shopeease/screens/order.dart';
import 'package:shopeease/screens/profile.dart';
import 'package:shopeease/screens/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  // late -> non-nullable variable. used when can't initalize variable immediatly. will use it before initialization

  late List<Widget> pages;
  late Widget currentScreen;

  late HomeScreen home;
  late WalletScreen wallet;
  late OrderScreen order;
  late ProfileScreen profile;

  @override
  void initState() {
    home = HomeScreen();
    wallet = WalletScreen();
    order = OrderScreen();
    profile = ProfileScreen();
    pages = [home, order, wallet, profile];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.green,
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
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 28.0,
          ),
          Icon(
            Icons.wallet_outlined,
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
