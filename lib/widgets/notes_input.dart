import 'package:flutter/material.dart';

class NotesInput extends StatelessWidget {
  final String notes;
  final Function(String) onChanged;

  const NotesInput({Key? key, required this.notes, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Enter a quick note',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade400), // Blue border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade400), // Blue border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2.0), // Darker blue border when focused
          ),
          filled: true,
          fillColor: Colors.blue.shade50, // Light blue background
        ),
        maxLines: 1,
      ),
    );
  }
}
