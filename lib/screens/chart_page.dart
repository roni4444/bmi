import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/shared_appbar.dart';

import '../constraints.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 5,
        pageContext: context,
      ),
      floatingActionButtonLocation: kFloatingActionButtonLocation,
      floatingActionButton: FloatingAction(
        label: "N0 ACTION",
        function: () {},
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                FontAwesomeIcons.exclamationTriangle,
                color: Colors.amber,
                size: 200.0,
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Page is under construction",
                  style: TextStyle(fontSize: 50, overflow: TextOverflow.fade),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
