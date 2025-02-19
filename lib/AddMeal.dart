import 'dart:convert';
import 'package:dietary_log_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMealScreen extends StatefulWidget {
  final Function(String mealType, int calories, double carbs, double protein,
      double fat) onSave;

  AddMealScreen({required this.onSave});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  String? _mealType = 'Breakfast';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _saveMeal() async {
    if (_foodController.text.isEmpty || _caloriesController.text.isEmpty)
      return;

    final newMeal = {
      'foodName': _foodController.text,
      'calories': int.parse(_caloriesController.text),
      'mealType': _mealType,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'time': _selectedTime.format(context),
      'carbs': double.parse(_carbsController.text),
      'protein': double.parse(_proteinController.text),
      'fat': double.parse(_fatController.text),
    };

    await FirebaseFirestore.instance.collection('meals').add(newMeal);

    widget.onSave(
      _mealType!,
      int.parse(_caloriesController.text),
      double.parse(_carbsController.text),
      double.parse(_proteinController.text),
      double.parse(_fatController.text),
    );

    setState(() {
      _foodController.clear();
      _caloriesController.clear();
      _carbsController.clear();
      _proteinController.clear();
      _fatController.clear();
      _mealType = 'Breakfast';
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DietaryLogPage()),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/addmeals.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 60),
                Text('Add My Meals',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 202, 3, 16))),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(255, 237, 241, 241).withOpacity(0.5),
                          spreadRadius: 10,
                          blurRadius: 8),
                    ],
                    backgroundBlendMode: BlendMode.colorBurn,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 1),
                  child: Column(
                    children: [
                      TextField(
                          controller: _foodController,
                          decoration: InputDecoration(
                              labelText: 'Food Name',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              border: OutlineInputBorder())),
                      SizedBox(height: 12),
                      TextField(
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Calories',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              border: OutlineInputBorder())),
                      SizedBox(height: 12),
                      TextField(
                          controller: _carbsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Carbs',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              border: OutlineInputBorder())),
                      SizedBox(height: 12),
                      TextField(
                          controller: _proteinController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Protein',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              border: OutlineInputBorder())),
                      SizedBox(height: 12),
                      TextField(
                          controller: _fatController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Fat',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              border: OutlineInputBorder())),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _mealType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _mealType = newValue;
                          });
                        },
                        items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                            .map((mealType) => DropdownMenuItem(
                                value: mealType, child: Text(mealType, style: TextStyle(fontWeight: FontWeight.bold),)))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                              'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 35, 5, 155))),
                          IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Time: ${_selectedTime.format(context)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: const Color.fromARGB(255, 35, 5, 155))),
                          IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () => _selectTime(context)),
                        ],
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                          onPressed: _saveMeal,
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                          child: Text('Save Meal',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 17))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
