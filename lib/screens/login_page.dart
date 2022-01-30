import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/shared_appbar.dart';
import 'package:mybmi/constraints.dart';
import 'package:mybmi/screens/profile_page.dart';
import 'package:mybmi/screens/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool _registered;

  @override
  void dispose() {
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> getRegistered() async {
    _registered = await _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("IsRegistered") ?? false;
    });
    auth.userChanges().listen((User? user) {
      if (!_registered) {
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
    getRegistered();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(
      height: 25.0,
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
        label: "SIGN IN",
        function: () {
          if (_formKey.currentState!.validate()) {
            try {
              userCredential = auth
                  .signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passController.text)
                  .then((value) {
                //auth.currentUser!.updatePhotoURL(photoURL);
              }).then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      )) as UserCredential;
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                return "No user found for that email.";
              } else if (e.code == 'wrong-password') {
                return "Wrong Password";
              } else {
                return "Unknown error";
              }
            }
          }
        },
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              spacing,
              const Center(
                child: Text(
                  "Login Page",
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 30.0),
                ),
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
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
