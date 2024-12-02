import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF00FFED),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: BMIForm(),
          ),
        ),
      ),
    );
  }
}

class BMIForm extends StatefulWidget {
  @override
  _BMIFormState createState() => _BMIFormState();
}

class _BMIFormState extends State<BMIForm> {
  int weight = 60;
  int age = 25;
  double height = 170.0;
  double? bmi;

  String getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return "Normal weight";
    } else if (bmi >= 25 && bmi <= 29.9) {
      return "Overweight";
    } else {
      return "Obesity";
    }
  }

  void calculateBmi() {
    double heightInMeters = height / 100;
    setState(() {
      bmi = weight / pow(heightInMeters, 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    String bmiCategory = bmi != null ? getBmiCategory(bmi!) : '';
    String bmiText = bmi != null ? bmi!.toStringAsFixed(1) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        const Text(
          'Welcome',
          style: TextStyle(fontSize: 28.0, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        const Text(
          'BMI Calculator',
          style: TextStyle(fontSize: 36.0, color: Colors.white),
        ),
        const SizedBox(height: 16.0),
        GenderSelection(),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueBox(
              title: 'Weight',
              initialValue: weight,
              unit: 'kg',
              heightFactor: 0.7,
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            const SizedBox(width: 20.0),
            ValueBox(
              title: 'Age',
              initialValue: age,
              heightFactor: 0.7,
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        const Text(
          'Height',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        const SizedBox(height: 10.0),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              height = double.tryParse(value) ?? height;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter your height in cm',
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        const SizedBox(height: 30.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bmiText,
              style: const TextStyle(
                fontSize: 48.0,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              bmiCategory,
              style: const TextStyle(
                fontSize: 28.0,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            calculateBmi();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            "Calculate",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}

class GenderSelection extends StatefulWidget {
  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String _selectedGender = 'Male';

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GenderButton(
            gender: 'Male',
            isSelected: _selectedGender == 'Male',
            onTap: () => _selectGender('Male'),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: GenderButton(
            gender: 'Female',
            isSelected: _selectedGender == 'Female',
            onTap: () => _selectGender('Female'),
          ),
        ),
      ],
    );
  }
}

class GenderButton extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.teal, width: 2.0),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 20.0,
              color: isSelected ? Colors.white : Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}

class ValueBox extends StatefulWidget {
  final String title;
  final int initialValue;
  final String? unit;
  final double heightFactor;
  final Function(int) onChanged;

  const ValueBox({
    required this.title,
    required this.initialValue,
    this.unit,
    this.heightFactor = 1.0,
    required this.onChanged,
  });

  @override
  _ValueBoxState createState() => _ValueBoxState();
}

class _ValueBoxState extends State<ValueBox> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _value++;
      widget.onChanged(_value);
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 0) _value--;
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            Text(
              '$_value${widget.unit ?? ''}',
              style: const TextStyle(fontSize: 36.0, color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _decrement,
                  child: const Icon(Icons.remove_circle, color: Colors.teal, size: 48.0),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: _increment,
                  child: const Icon(Icons.add_circle, color: Colors.teal, size: 48.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
