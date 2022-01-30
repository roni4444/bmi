import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/shared_appbar.dart';
import 'package:mybmi/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constraints.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  List<Widget> bmiList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String uid = "";
  String email = "";

  @override
  void initState() {
    auth.userChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
    prepareAndShowBMI();
    super.initState();
  }

  Future<void> prepareAndShowBMI() async {
    uid = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserUID") ?? "null";
    });
    email = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserDisplayEmail") ?? "null";
    });
    showBMI();
    setState(() {});
  }

  Future<void> showBMI() async {
    int x = 1;
    firestore
        .collection("users")
        .doc(email)
        .collection("bmi")
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        bmiList.add(ListTile(
          leading: Text(x.toString()),
          title: doc["BMI"],
          subtitle: doc["Status"],
          trailing: doc["Date.Day"],
        ));
        x = x + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 4,
        pageContext: context,
      ),
      floatingActionButtonLocation: kFloatingActionButtonLocation,
      floatingActionButton: FloatingAction(
        label: "LOAD MORE",
        function: () {},
      ),
      body: SafeArea(
        child: ListView(
          children: bmiList,
        ),
      ),
    );
  }
}
