import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/calculator_brain.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/shared_appbar.dart';
import 'package:mybmi/constraints.dart';
import 'package:mybmi/screens/login_page.dart';
import 'package:mybmi/screens/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender {
  male,
  female,
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Gender selectedGender = Gender.male;
  String gender = "Male";
  String name = "Your Name";
  String emailId = "Your Email Id";
  int height = 180;
  int weight = 60;
  int age = 18;
  IconData icon = FontAwesomeIcons.child;
  Color mc = Colors.white;
  Color fc = Colors.white;

  late bool _registered;
  DateTime dateTime = DateTime.now();
  int feet = 5;
  int inches = 5;
  int day = 1;
  int month = 1;
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int year = 1900;
  //int setStateFlag = 0;

  Future<void> getSharedPreferences() async {
    _registered = await _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("IsRegistered") ?? false;
    });
    name = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserDisplayName") ?? "Your Name";
    });
    emailId = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserDisplayEmail") ?? "Your Email Id";
    });
    gender = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserGender") ?? "Male";
    });
    selectedGender =
        (gender.compareTo("Male") == 0) ? Gender.male : Gender.female;
    feet = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserHeightFeet") ?? 5;
    });
    inches = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserHeightInches") ?? 5;
    });
    height = ((((feet) * 12) + (inches)) * 2.54).ceil();
    weight = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserWeightKg") ?? 50;
    });
    weight = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserWeightKg") ?? 50;
    });
    year = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserDOBYear") ?? 1900;
    });
    month = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserDOBMonth") ?? 1;
    });
    day = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserDOBDay") ?? 1;
    });
    dateTime = DateTime(year, month, day);
    int x = dateTime.difference(DateTime.now()).inDays;
    if (DateTime(1900, 1, 1).difference(DateTime.now()).inDays == x) {
      x = 365 * 10;
    }
    if (x < 0) {
      x = (-1) * x;
    }
    age = (x / 365).floor();
    auth.userChanges().listen((User? user) {
      if (_registered) {
        if (user == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        } else {
          _prefs.then((SharedPreferences prefs) {
            prefs.setString("UserUID", auth.currentUser!.uid);
          });
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistrationPage(),
          ),
        );
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    getSharedPreferences();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
      ),
      floatingActionButtonLocation: kFloatingActionButtonLocation,
      floatingActionButton: FloatingAction(
        label: "",
        function: () {},
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 1,
        pageContext: context,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      Icon(
                        (selectedGender == Gender.male)
                            ? FontAwesomeIcons.mars
                            : FontAwesomeIcons.venus,
                        color: (selectedGender == Gender.male)
                            ? Colors.blueAccent
                            : Colors.purpleAccent,
                        size: 150.0,
                      ),
                      Positioned(
                        top: (selectedGender == Gender.male) ? 65.0 : 27,
                        left: (selectedGender == Gender.male) ? 30.0 : 44,
                        child: const CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.transparent,
                          /*child: Image(
                        image: AssetImage("images/playstore.png"),
                    ),*/
                          /*backgroundImage:
                              AssetImage("images/blank_profile.png"),*/
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(emailId),
                    ],
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.weight),
                title: Text(weight.toString() + " Kg"),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.arrowsAltV),
                title: Text(
                    feet.toString() + " Feet " + inches.toString() + " Inches"),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.birthdayCake),
                title: Text(day.toString() +
                    " / " +
                    month.toString() +
                    " / " +
                    year.toString()),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "My BMI",
                style: TextStyle(
                  fontSize: 60,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                CalculatorBrain(height, weight).calculateBMI(),
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    CalculatorBrain(height, weight).getWeightChange(),
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}
