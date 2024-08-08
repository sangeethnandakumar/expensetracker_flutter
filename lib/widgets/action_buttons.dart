import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final Function() onAddExpense;
  final Function() onAddIncome;

  const ActionButtons({
    Key? key,
    required this.onAddExpense,
    required this.onAddIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreenAccent, Colors.greenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ElevatedButton.icon(
                onPressed: onAddIncome,
                icon: Icon(Icons.keyboard_double_arrow_up_outlined, color: Colors.white), // Add icon here
                label: Text(
                  'ADD INCOME'.toUpperCase(), // Convert text to uppercase
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Increased vertical padding
                  textStyle: TextStyle(fontSize: 15.0), // Increased font size
                  elevation: 5, // Add elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.transparent, // Make the button background transparent
                ),
              ),
            ),
          ),
          SizedBox(width: 8), // Add some space between buttons
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellowAccent, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ElevatedButton.icon(
                onPressed: onAddExpense,
                icon: Icon(Icons.keyboard_double_arrow_down_outlined, color: Colors.white), // Add icon here
                label: Text(
                  'ADD EXPENSE'.toUpperCase(), // Convert text to uppercase
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Increased vertical padding
                  textStyle: TextStyle(fontSize: 15.0), // Increased font size
                  elevation: 5, // Add elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.transparent, // Make the button background transparent
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
