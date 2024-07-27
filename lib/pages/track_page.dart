// track_page.dart
import 'package:flutter/material.dart';
import 'category_editor.dart'; // Import the new page
import '../widgets/categorygrid.dart';
import '../widgets/currencyeditor.dart';
import '../widgets/keypad.dart';
import '../widgets/action_buttons.dart';
import '../widgets/notes_input.dart';
import '../api.dart';
import '../models/CategoryModel.dart';

class TrackPage extends StatefulWidget {
  final Function onSuccess;

  const TrackPage({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  String _money = '0';
  String _notes = '';
  String _category = '';
  List<CategoryModel> _categories = []; // Add this to hold categories

  void _onKeyPress(String value) {
    setState(() {
      _money = value;
    });
  }

  void _onCategorySelected(String categoryGuid) {
    setState(() {
      _category = categoryGuid;
    });
  }

  void _addExpense() async {
    if (_notes.isEmpty || double.tryParse(_money) == null || double.tryParse(_money)!.round() <= 0 || _category.isEmpty) {
      _showSnackbar("Please enter valid expense, notes, and select a category", Colors.red);
      return;
    }

    final expenseData = {
      "exp": double.tryParse(_money)!.round(),
      "inc": 0,
      "notes": _notes,
      "category": _category,
    };

    Api.post(
      '/tracks',
      expenseData,
          (response) async {
        _showSnackbar("Expense added successfully!", Colors.green);
        widget.onSuccess();
        setState(() {
          _money = '0';
          _notes = '';
        });
      },
          (error) {
        _showSnackbar("Failed to add expense: $error", Colors.red);
      },
    );
  }

  void _addIncome() {
    _showSnackbar("Income added successfully!", Colors.green);
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openCategoryEditor() {
    // Navigate to category editor page with categories
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryEditorPage(categories: _categories),
      ),
    );
  }

  void _setCategories(List<CategoryModel> categories) {
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: CurrencyEditor(money: _money),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: _openCategoryEditor,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.edit, color: Colors.blue.shade900),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: CategoryGrid(
                onCategorySelected: _onCategorySelected,
                setCategories: _setCategories, // Add this to set categories
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: NotesInput(
              notes: _notes,
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ActionButtons(
              onAddExpense: _addExpense,
              onAddIncome: _addIncome,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: KeyPad(
              allowDecimal: true,
              allowClear: true,
              disable: false,
              maxAllowed: 100000,
              value: double.tryParse(_money) ?? 0.0,
              seedColor: Colors.blue.shade100,
              onKeyPress: _onKeyPress,
            ),
          ),
        ],
      ),
    );
  }
}
