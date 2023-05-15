import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/ui/home_user.dart';

import 'cart.dart';
import 'favourite.dart';

import 'profile.dart';

class ButtomNuvUser extends StatefulWidget {
  const ButtomNuvUser({Key? key}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeUser(),
    const Favourite(),
    const Cart(),
    Profile()
  ];

  @override
  State<ButtomNuvUser> createState() => _ButtomNuvUserState();
}

class _ButtomNuvUserState extends State<ButtomNuvUser> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ButtomNuvUser._widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.appblue,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              backgroundColor: AppColors.appblue,
              tabBackgroundColor: Colors.blue[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'หน้าหลัก',
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'ถูกใจ',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'ค้นหา',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'ตั้งค่า',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
