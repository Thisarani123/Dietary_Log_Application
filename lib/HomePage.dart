import 'package:flutter/material.dart';
import 'package:dietary_log_app/AddMeal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DietaryLogPage extends StatefulWidget {
  @override
  _DietaryLogPageState createState() => _DietaryLogPageState();
}

class _DietaryLogPageState extends State<DietaryLogPage> {
  DateTime selectedDate = DateTime.now();
  int totalCalories = 0;

  Map<String, Map<String, dynamic>> meals = {
    'Breakfast': {'calories': 0, 'carbs': 0.0, 'protein': 0.0, 'fat': 0.0},
    'Lunch': {'calories': 0, 'carbs': 0.0, 'protein': 0.0, 'fat': 0.0},
    'Dinner': {'calories': 0, 'carbs': 0.0, 'protein': 0.0, 'fat': 0.0},
    'Snack': {'calories': 0, 'carbs': 0.0, 'protein': 0.0, 'fat': 0.0},
  };

  @override
  void initState() {
    super.initState();
    _loadMealData();
  }

  _loadMealData() async {
    FirebaseFirestore.instance
        .collection('meals')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate))
        .get()
        .then((querySnapshot) {
      setState(() {
        meals.forEach((mealType, mealData) {
          mealData['calories'] = 0;
          mealData['carbs'] = 0.0;
          mealData['protein'] = 0.0;
          mealData['fat'] = 0.0;
        });

        querySnapshot.docs.forEach((doc) {
          var mealData = doc.data() as Map<String, dynamic>;
          String mealType = mealData['mealType'];
          meals[mealType]!['calories'] += mealData['calories'] as int;
          meals[mealType]!['carbs'] += mealData['carbs'] as double;
          meals[mealType]!['protein'] += mealData['protein'] as double;
          meals[mealType]!['fat'] += mealData['fat'] as double;
          totalCalories += mealData['calories'] as int;
        });
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _loadMealData();
      });
    }
  }

  void _updateMealData(String mealType, int calories, double carbs, double protein, double fat) {
    setState(() {
      meals[mealType]!['calories'] += calories;
      meals[mealType]!['carbs'] += carbs;
      meals[mealType]!['protein'] += protein;
      meals[mealType]!['fat'] += fat;
      totalCalories += calories;
    });

    FirebaseFirestore.instance.collection('meals').add({
      'mealType': mealType,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 20),
                    _buildCalorieIndicator(),
                    SizedBox(height: 20),
                    _buildMacrosBar(),
                    SizedBox(height: 20),
                    _buildAddMealButton(context),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: const Color.fromARGB(255, 6, 14, 240)),
                          SizedBox(width: 5),
                          Text(
                            _formatDate(selectedDate),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildMealCard("Breakfast", meals['Breakfast']!['calories'].toString(), "assets/images/breakfast.png"),
                    _buildMealCard("Lunch", meals['Lunch']!['calories'].toString(), "assets/images/lunch.png"),
                    _buildMealCard("Dinner", meals['Dinner']!['calories'].toString(), "assets/images/dinner.png"),
                    _buildMealCard("Snacks", meals['Snack']!['calories'].toString(), "assets/images/snacks.png"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    DateTime today = DateTime.now();
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return "Today";
    }
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  Widget _buildHeader() {
    DateTime today = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,  
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        SizedBox(width: 20),  
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("HELLO,", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("USER", style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 196, 24, 104), fontSize: 15)),
          ],
        ),
         
      ],
    );
  }

  Widget _buildCalorieIndicator() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: const Color.fromARGB(255, 179, 22, 11),
      child: Text(
        "$totalCalories kcal",
        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMacrosBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroItem('Carbs', meals['Breakfast']!['carbs']),
        _buildMacroItem('Protein', meals['Breakfast']!['protein']),
        _buildMacroItem('Fat', meals['Breakfast']!['fat']),
      ],
    );
  }

  Widget _buildMacroItem(String label, double value) {
    return Column(
      children: [
        Text(value.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }

  Widget _buildAddMealButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMealScreen(onSave: _updateMealData),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
    ),
      child: Text('Add Meal',style: TextStyle(color: const Color.fromARGB(255, 250, 249, 249)),),
    );
  }

  Widget _buildMealCard(String mealType, String calories, String image) {
    return GestureDetector(
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Image.asset(image),
          title: Text(mealType),
          subtitle: Text('Calories: $calories'),
        ),
      ),
    );
  }
}
