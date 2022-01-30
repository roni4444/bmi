import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mybmi/components/bottom_navigation.dart';
import 'package:mybmi/components/floating_action.dart';
import 'package:mybmi/components/icon_content.dart';
import 'package:mybmi/components/reusable_card.dart';
import 'package:mybmi/components/round_icon_button.dart';
import 'package:mybmi/components/shared_appbar.dart';
import 'package:mybmi/screens/results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../calculator_brain.dart';
import '../constraints.dart';

enum Gender {
  male,
  female,
  none,
}

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender selectedGender = Gender.none;
  String gender = "Male";
  int height = 180;
  int weight = 50;
  int age = 18;
  IconData icon = FontAwesomeIcons.male;
  Color mc = Colors.white;
  Color fc = Colors.white;
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool _registered;
  DateTime dateTime = DateTime.now();

  void yes() {
    setState(() {});
  }

  Future<void> getSharedPreferences() async {
    _registered = await _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("IsRegistered") ?? false;
    });
    gender = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString("UserGender") ?? "Male";
    });
    selectedGender =
        (gender.compareTo("Male") == 0) ? Gender.male : Gender.female;
    height = ((((await _prefs.then((SharedPreferences prefs) {
                      return prefs.getInt("UserHeightFeet") ?? 5;
                    })) *
                    12) +
                (await _prefs.then((SharedPreferences prefs) {
                  return prefs.getInt("UserHeightInches") ?? 5;
                }))) *
            2.54)
        .ceil();
    weight = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserWeightKg") ?? 50;
    });
    weight = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("UserWeightKg") ?? 50;
    });
    dateTime = DateTime(
        await _prefs.then((SharedPreferences prefs) {
          return prefs.getInt("UserDOBYear") ?? 1900;
        }),
        await _prefs.then((SharedPreferences prefs) {
          return prefs.getInt("UserDOBMonth") ?? 1;
        }),
        await _prefs.then((SharedPreferences prefs) {
          return prefs.getInt("UserDOBDay") ?? 1;
        }));
    int x = dateTime.difference(DateTime.now()).inDays;
    if (DateTime(1900, 1, 1).difference(DateTime.now()).inDays == x) {
      x = 365 * 10;
    }
    if (x < 0) {
      x = (-1) * x;
    }
    age = (x / 365).floor();
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
      bottomNavigationBar: BottomNavigation(
        currentIndex: 0,
        pageContext: context,
      ),
      floatingActionButton: FloatingAction(
        label: 'CALCULATE',
        function: () {
          CalculatorBrain calc = CalculatorBrain(height, weight);
          if (selectedGender != Gender.none) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsPage(
                  bmiResult: calc.calculateBMI(),
                  resultText: calc.getResult(),
                  interpretation: calc.getWeightChange(),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 56.0),
                content: Text(
                  "Select the gender",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: kFloatingActionButtonLocation,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    setState(() {
                      selectedGender = Gender.male;
                      mc = Colors.blueAccent;
                      fc = Colors.white;
                      icon = FontAwesomeIcons.male;
                    });
                  },
                  colour: selectedGender == Gender.male
                      ? kActiveCardColour
                      : kInactiveCardColour,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.mars,
                    label: 'MALE',
                    colour: mc,
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    setState(() {
                      selectedGender = Gender.female;
                      fc = Colors.purpleAccent;
                      mc = Colors.white;
                      icon = FontAwesomeIcons.female;
                    });
                  },
                  colour: selectedGender == Gender.female
                      ? kActiveCardColour
                      : kInactiveCardColour,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.venus,
                    label: 'FEMALE',
                    colour: fc,
                  ),
                ),
              ),
            ],
          )),
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'HEIGHT',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            height.toString(),
                            style: kNumberTextStyle,
                          ),
                          const Text(
                            '  cm',
                            style: kLabelTextStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            ((((height * 0.393701).floor()) / 12).floor())
                                .toString(),
                            style: kNumberTextStyle,
                          ),
                          const Text(
                            'feet',
                            style: kLabelTextStyle,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            (((((height * 0.393701).floor()) / 12) -
                                        ((((height * 0.393701).floor()) / 12)
                                            .floor())) *
                                    12)
                                .round()
                                .toString(),
                            style: kNumberTextStyle,
                          ),
                          const Text(
                            'inch',
                            style: kLabelTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RoundIconButton(
                          icon: FontAwesomeIcons.angleLeft,
                          onPressed: () {
                            setState(() {
                              height--;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: const Color(0xFF8D8E98),
                            activeTrackColor: Colors.white,
                            thumbColor: const Color(0xFFEB1555),
                            overlayColor: const Color(0x29EB1555),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 15.0),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 30.0),
                          ),
                          child: Slider(
                            value: height.toDouble(),
                            min: 30.0,
                            max: 300.0,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: RoundIconButton(
                          icon: FontAwesomeIcons.angleRight,
                          onPressed: () {
                            setState(() {
                              height++;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'WEIGHT',
                          style: kLabelTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              weight.toString(),
                              style: kNumberTextStyle,
                            ),
                            const Text(
                              ' kg',
                              style: kLabelTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              data: "Change",
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) {
                                        return AlertDialog(
                                          title: const Center(
                                            child: Text("Weight"),
                                          ),
                                          content: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (weight > 5) {
                                                          weight = weight - 1;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "1",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        weight = weight - 5;
                                                        if (weight < 5) {
                                                          weight = 5;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "5",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        weight = weight - 10;
                                                        if (weight < 5) {
                                                          weight = 5;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "10",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        weight = weight - 20;
                                                        if (weight < 5) {
                                                          weight = 5;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "20",
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(weight.toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text("Kg"),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (weight < 140) {
                                                          weight = weight + 1;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "1",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        weight = weight + 5;
                                                        if (weight > 140) {
                                                          weight = 140;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "5",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        weight = weight + 10;
                                                        if (weight > 140) {
                                                          weight = 140;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "10",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        weight = weight + 20;
                                                        if (weight > 140) {
                                                          weight = 140;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "20",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            RoundIconButton(
                                              data: "Yes",
                                              onPressed: () {
                                                yes();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ),
                            /*RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(() {
                                    if (weight > 5) {
                                      weight--;
                                    }
                                  });
                                }),
                            const SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  if (weight < 140) {
                                    weight++;
                                  }
                                });
                              },
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'AGE',
                                  style: kLabelTextStyle,
                                ),
                                Text(
                                  age.toString(),
                                  style: kNumberTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Icon(icon),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              data: "Change",
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) {
                                        return AlertDialog(
                                          title: const Center(
                                            child: Text("Age"),
                                          ),
                                          content: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (age > 5) {
                                                          age = age - 1;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "1",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        age = age - 5;
                                                        if (age < 5) {
                                                          age = 5;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "5",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        age = age - 10;
                                                        if (age < 5) {
                                                          age = 5;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "10",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        age = age - 20;
                                                        if (age < 5) {
                                                          age = 5;
                                                        }
                                                      });
                                                    },
                                                    icon:
                                                        FontAwesomeIcons.minus,
                                                    data: "20",
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(age.toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text("Years"),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (age < 105) {
                                                          age = age + 1;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "1",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        age = age + 5;
                                                        if (age > 105) {
                                                          age = 105;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "5",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        age = age + 10;
                                                        if (age > 105) {
                                                          age = 105;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "10",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RoundIconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        age = age + 20;
                                                        if (age > 105) {
                                                          age = 105;
                                                        }
                                                      });
                                                    },
                                                    icon: FontAwesomeIcons.plus,
                                                    data: "20",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            RoundIconButton(
                                              data: "Yes",
                                              onPressed: () {
                                                yes();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ),
                            /*RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(
                                  () {
                                    if (age > 5) {
                                      age--;
                                    }
                                    if (age <= 5) {
                                      icon = FontAwesomeIcons.baby;
                                    } else if (age <= 18) {
                                      icon = FontAwesomeIcons.child;
                                    } else if (age <= 60) {
                                      if (selectedGender == Gender.male) {
                                        icon = FontAwesomeIcons.male;
                                      } else {
                                        icon = FontAwesomeIcons.female;
                                      }
                                    } else if (age <= 100) {
                                      icon = FontAwesomeIcons.hiking;
                                    } else {
                                      age--;
                                    }
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                onPressed: () {
                                  setState(() {
                                    if (age < 105) {
                                      age++;
                                    }
                                    if (age <= 5) {
                                      icon = FontAwesomeIcons.baby;
                                    } else if (age <= 18) {
                                      icon = FontAwesomeIcons.child;
                                    } else if (age <= 60) {
                                      if (selectedGender == Gender.male) {
                                        icon = FontAwesomeIcons.male;
                                      } else {
                                        icon = FontAwesomeIcons.female;
                                      }
                                    } else if (age <= 100) {
                                      icon = FontAwesomeIcons.hiking;
                                    } else {
                                      age--;
                                    }
                                  });
                                },)*/
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kBottomContainerHeight / 2,
          ) /*
          BottomButton(
            buttonTitle: 'CALCULATE',
            onTap: () {
              CalculatorBrain calc = CalculatorBrain(height, weight);
              if (selectedGender != Gender.none) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(
                      bmiResult: calc.calculateBMI(),
                      resultText: calc.getResult(),
                      interpretation: calc.getWeightChange(),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: kInactiveCardColour,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 56.0),
                    content: Text(
                      "Select the gender",
                      style: TextStyle(
                        color: Color(0xFF8D8E98),
                      ),
                    ),
                  ),
                );
              }
            },
          ),*/
        ],
      ),
    );
  }
}
