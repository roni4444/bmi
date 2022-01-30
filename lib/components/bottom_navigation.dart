import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/constraints.dart';
import 'package:mybmi/screens/chart_page.dart';
import 'package:mybmi/screens/history_page.dart';
import 'package:mybmi/screens/input_page.dart';
import 'package:mybmi/screens/login_page.dart';
import 'package:mybmi/screens/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation(
      {Key? key, required this.currentIndex, required this.pageContext})
      : super(key: key);
  final int currentIndex;
  final BuildContext pageContext;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void navigateToPage(int position) {
    auth.userChanges().listen((User? user) {
      if (user != null) {
        switch (position) {
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryPage(),
              ),
            );
            break;
          case 5:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChartPage(),
              ),
            );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      iconSize: 30,
      currentIndex: widget.currentIndex,
      backgroundColor: kActiveCardColour,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(FontAwesomeIcons.home),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(FontAwesomeIcons.userTie),
        ),
        BottomNavigationBarItem(
          tooltip: null,
          label: "",
          icon: Icon(
            FontAwesomeIcons.angleUp,
            color: kActiveCardColour,
          ),
        ), //BMI Result Page
        BottomNavigationBarItem(
          tooltip: null,
          label: "",
          icon: Icon(
            FontAwesomeIcons.angleUp,
            color: kActiveCardColour,
          ),
        ),
        BottomNavigationBarItem(
          label: "History",
          icon: Icon(FontAwesomeIcons.history),
        ),
        BottomNavigationBarItem(
          label: "Charts",
          icon: Icon(FontAwesomeIcons.chartPie),
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          if (widget.currentIndex == 2) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InputPage(),
              ),
            );
          }
        } else {
          navigateToPage(index);
        }
      },
    );
  }
}
