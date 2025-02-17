import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DietaryLogPage extends StatefulWidget {
  @override
  _DietaryLogPageState createState() => _DietaryLogPageState();
}

class _DietaryLogPageState extends State<DietaryLogPage> {
  DateTime selectedDate = DateTime.now();

  int totalCalories = 0;
  double totalCarbs = 0.0;
  double totalProtein = 0.0;
  double totalFat = 0.0;

  void _updateMealData(int calories, double carbs, double protein, double fat) {
    setState(() {
      totalCalories += calories;
      totalCarbs += carbs;
      totalProtein += protein;
      totalFat += fat;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 212, 212),
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
                   
                    SizedBox(height: 20),
                    _buildAddMealButton(context),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.black),
                          SizedBox(width: 5),
                          Text(
                            _formatDate(selectedDate),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildMealCard(
                        "Breakfast", "243kcal", "assets/images/breakfast.png"),
                    _buildMealCard(
                        "Lunch", "335kcal", "assets/images/lunch.png"),
                    _buildMealCard(
                        "Dinner", "0kcal", "assets/images/dinner.png"),
                    _buildMealCard(
                        "Snacks", "0kcal", "assets/images/snacks.png"),
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
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return "Today";
    }
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.jpg'),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("HELLO,", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("NUWAN", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            Text("10"),
            Text("FEB", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildCalorieIndicator() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.red,
      child: Text(
        "$totalCalories kcal",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  Widget _buildAddMealButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // onPressed: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => AddMealScreen(
      //         onSave: _updateMealData,
      //       ),
      //     ),
      //   );
      // },
      onPressed: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          "Add My Meals",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMacroIndicator(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 5,
          color: color,
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildMealCard(String meal, String calories, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(imagePath, width: 30, height: 30),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(calories,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(meal),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_circle, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
