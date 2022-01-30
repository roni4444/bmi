import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/shared_appbar.dart';
import 'package:mybmi/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constraints.dart';

enum Gender {
  male,
  female,
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late UserCredential userCredential;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Gender selectedGender = Gender.male;
  DateTime _selectedDateTime = DateTime.now();
  int weight = 50;
  int inch = 5;
  int feet = 5;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }

  Future<void> addUser(String email, String name, String gender, int feet,
      int inches, int weight, int dobday, int dobmonth, int dobyear) async {
    return firestore.collection('users').doc(email).set({
      'Email': email,
      'Name': name,
      'Gender': gender,
      'Height': {
        'Feet': feet,
        'Inches': inches,
      },
      'Weight': weight,
      'DOB': {
        'Day': dobday,
        'Month': dobmonth,
        'Year': dobyear,
      },
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(
      height: 15.0,
    );
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 3,
        pageContext: context,
      ),
      floatingActionButtonLocation: kFloatingActionButtonLocation,
      floatingActionButton: FloatingAction(
        label: "REGISTER",
        function: () {
          if (_formKey.currentState!.validate()) {
            try {
              userCredential = auth
                  .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passController.text)
                  .then((value) {
                _prefs.then((SharedPreferences prefs) {
                  prefs.setBool("IsRegistered", true);
                  prefs.setString("UserDisplayName", _nameController.text);
                  prefs.setString("UserDisplayEmail", _emailController.text);
                  prefs.setString("UserGender",
                      (selectedGender == Gender.male) ? "Male" : "Female");
                  prefs.setInt("UserHeightInches", inch);
                  prefs.setInt("UserHeightFeet", feet);
                  prefs.setInt("UserWeightKg", weight);
                  prefs.setInt("UserDOBDay", _selectedDateTime.day);
                  prefs.setInt("UserDOBMonth", _selectedDateTime.month);
                  prefs.setInt("UserDOBYear", _selectedDateTime.year);
                });
                addUser(
                        _emailController.text,
                        _nameController.text,
                        (selectedGender == Gender.male) ? "Male" : "Female",
                        feet,
                        inch,
                        weight,
                        _selectedDateTime.day,
                        _selectedDateTime.month,
                        _selectedDateTime.year)
                    .whenComplete(() => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ));
              }) as UserCredential;
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                return "The password provided is too weak";
              } else if (e.code == 'email-already-in-use') {
                return "The account already exists for that email";
              } else if (e.code == 'invalid-emil') {
                return "The email id is not valid";
              } else {
                return "Unknown error";
              }
            } catch (e) {
              return e.toString();
            }
          }
        },
      ),
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    spacing,
                    const Center(
                      child: Text(
                        "Registration Page",
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                    spacing,
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        filled: false,
                        icon: Icon(FontAwesomeIcons.user),
                        labelText: "Your Name",
                        hintText: "Enter your name here",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                    ),
                    spacing,
                    ListTile(
                      leading: const Text(
                        "Gender",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            const Text("Female"),
                            Switch(
                                value: (selectedGender == Gender.male)
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (value) {
                                      selectedGender = Gender.male;
                                    } else {
                                      selectedGender = Gender.female;
                                    }
                                  });
                                }),
                            const Text("Male"),
                          ],
                        ),
                      ),
                      trailing: Icon((selectedGender == Gender.male)
                          ? FontAwesomeIcons.mars
                          : FontAwesomeIcons.venus),
                    ),
                    spacing,
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        filled: false,
                        icon: Icon(FontAwesomeIcons.envelope),
                        labelText: "Email",
                        hintText: "Enter your email id here",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                    ),
                    spacing,
                    ListTile(
                      leading: const Text("Date of Birth"),
                      title: ElevatedButton(
                        child: const Text("Pick Date"),
                        onPressed: () => _selectDate(context),
                      ),
                      trailing: Text(_selectedDateTime.day.toString() +
                          "/" +
                          _selectedDateTime.month.toString() +
                          "/" +
                          _selectedDateTime.year.toString()),
                    ),
                    spacing,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Weight"),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleUp),
                          onPressed: () {
                            setState(() {
                              weight = weight + 1;
                              if (weight > 140) {
                                weight = 140;
                              }
                            });
                          },
                        ),
                        Text(
                          weight.toString(),
                        ),
                        const Text(" KG"),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleDown),
                          onPressed: () {
                            setState(() {
                              weight = weight - 1;
                              if (weight < 0) {
                                weight = 0;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    spacing,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Height"),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleUp),
                          onPressed: () {
                            setState(() {
                              feet = feet + 1;
                              if (feet > 10) {
                                feet = 10;
                              }
                            });
                          },
                        ),
                        Text(
                          feet.toString(),
                        ),
                        const Text(" Feet"),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleDown),
                          onPressed: () {
                            setState(() {
                              feet = feet - 1;
                              if (feet < 0) {
                                feet = 0;
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleUp),
                          onPressed: () {
                            setState(() {
                              inch = inch + 1;
                              if (inch > 11) {
                                inch = 11;
                              }
                            });
                          },
                        ),
                        Text(
                          inch.toString(),
                        ),
                        const Text(" Inches"),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleDown),
                          onPressed: () {
                            setState(() {
                              inch = inch - 1;
                              if (inch < 0) {
                                inch = 0;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    spacing,
                    TextFormField(
                      controller: _passController,
                      decoration: const InputDecoration(
                        filled: false,
                        icon: Icon(FontAwesomeIcons.key),
                        labelText: "Password",
                        hintText: "Enter your password here",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                    ),
                    spacing,
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: false,
                        icon: Icon(FontAwesomeIcons.key),
                        labelText: "Re-Type Password",
                        hintText: "Enter your password again",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter some text";
                        } else if (value != _passController.text) {
                          return "Password didn't match";
                        }
                        return null;
                      },
                    ),
                    spacing,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
