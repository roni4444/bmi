import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/reusable_card.dart';
import 'package:mybmi/components/shared_appbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constraints.dart';

class ResultsPage extends StatefulWidget {
  final String bmiResult;
  final String resultText;
  final String interpretation;

  const ResultsPage(
      {Key? key,
      required this.bmiResult,
      required this.resultText,
      required this.interpretation})
      : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String uid = "";
  String email = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prepareAndAddBMI() async {
    uid = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserUID") ?? "";
    });
    email = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserDisplayEmail") ?? "";
    });
    addBMI();
    //setState(() {});
  }

  Future<void> addBMI() async {
    firestore.collection("users").doc(email).collection("bmi").add({
      'BMI': widget.bmiResult,
      'Status': widget.resultText,
      'interpretation': widget.interpretation,
      'Date': {
        'Day': DateTime.now().day,
        'Month': DateTime.now().month,
        'Year': DateTime.now().year,
      },
      'Time': {
        'Hr': DateTime.now().hour,
        'Min': DateTime.now().minute,
        'Sec': DateTime.now().second,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
      ),
      floatingActionButtonLocation: kFloatingActionButtonLocation,
      floatingActionButton: FloatingAction(
        label: 'RE-CALCULATE',
        function: () {
          Navigator.pop(context);
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 2,
        pageContext: context,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'BMI Result',
                style: kTitleTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.resultText.toUpperCase(),
                    style: (double.parse(widget.bmiResult) < 18.5)
                        ? const TextStyle(
                            color: Color(0xFF0278E2),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          )
                        : (double.parse(widget.bmiResult) > 25)
                            ? const TextStyle(
                                color: Color(0xFFFF0000),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              )
                            : const TextStyle(
                                color: Color(0xFF24D876),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                  ),
                  Text(
                    widget.bmiResult,
                    style: kBMITextStyle,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          prepareAndAddBMI()
                              .whenComplete(() => Navigator.pop(context));
                        },
                        elevation: 10.0,
                        child: const Text("Save"),
                      ),
                      FloatingActionButton(
                        onPressed: () => Share.share(
                          "My Bmi is" + widget.bmiResult.toString(),
                        ),
                        elevation: 10.0,
                        child: const Text("Share"),
                      ),
                    ],
                  ),
                  Text(
                    widget.interpretation,
                    textAlign: TextAlign.center,
                    style: kBodyTextStyle,
                  ),
                ],
              ),
            ),
          ),
          /*BottomButton(
            buttonTitle: 'RE-CALCULATE',
            onTap: () {
              Navigator.pop(context);
            },
          )*/
        ],
      ),
    );
  }
}
