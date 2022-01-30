import 'dart:math';

class CalculatorBrain {
  final int height;
  final int weight;

  double _bmi = 0.0;
  double _recMinWeight = 0.0;
  double _recMaxWeight = 0.0;
  double _recAVGWeight = 0.0;

  CalculatorBrain(this.height, this.weight);

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi >= 40) {
      return 'Obese (Class III)';
    } else if (_bmi >= 35) {
      return 'Obese (Class II)';
    } else if (_bmi >= 30) {
      return 'Obese (Class I)';
    } else if (_bmi >= 25) {
      return 'Overweight (Pre-obese)';
    } else if (_bmi >= 18.5) {
      return 'Normal';
    } else if (_bmi >= 17) {
      return 'Underweight (Mild thinness)';
    } else if (_bmi >= 16) {
      return 'Underweight (Moderate thinness)';
    } else {
      return 'Underweight (Severe thinness)';
    }
  }

  String getInterpretation() {
    if (_bmi >= 25) {
      return 'You have a higher weight than normal body weight. Try to exercise more.';
    } else if (_bmi >= 18.5) {
      return 'You have a normal body weight. Good job!';
    } else {
      return 'You have a lower weight than normal body weight. You can eat a bit more.';
    }
  }

  String getWeightChange() {
    _recMinWeight = 18.5 * pow(height / 100, 2);
    _recMaxWeight = 24.9 * pow(height / 100, 2);
    _recAVGWeight = (_recMaxWeight + _recMinWeight) / 2;

    if (_bmi < 18.5 || _bmi >= 25) {
      return "You should keep your weight between " +
          _recMinWeight.toStringAsFixed(1) +
          " Kg and " +
          _recMaxWeight.toStringAsFixed(1) +
          " Kg";
    } else {
      return "Your weight is perfect but try to stay around " +
          _recAVGWeight.toStringAsFixed(1) +
          " Kg";
    }
  }
}
