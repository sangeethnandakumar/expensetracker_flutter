import 'package:expences/models/record_model.dart';
import 'package:expences/pages/category_editor.dart';
import 'package:expences/widgets/loading.dart';
import 'package:flutter/material.dart';
import '../bl/repos/categories_repo.dart';
import '../bl/repos/records_repo.dart';
import '../models/category_model.dart';
import 'category_creation.dart';
import '../widgets/categorygrid.dart';
import '../widgets/currencyeditor.dart';
import '../widgets/keypad.dart';
import '../widgets/action_buttons.dart';
import '../widgets/notes_input.dart';
import 'package:uuid/uuid.dart';

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
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  final RecordRepository _recordRepository = RecordRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    var allCategories = await _categoryRepository.getAll();

    setState(() {
      _isLoading = false;
      _categories = allCategories;
      _category = allCategories.length > 0 ? allCategories[0].id : '';
    });
  }

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

    // Create a Record object
    final record = RecordModel(
      id: Uuid().v4(),
      date: DateTime.now().toUtc().toIso8601String(),
      amt: (double.tryParse(_money)!.round() * -1).toDouble(),
      notes: _notes,
      category: _category,
      isIncome: false
    );

    // Use the RecordRepository to add the record
    await _recordRepository.create(record);

    _showSnackbar("Expense added successfully!", Colors.green);
    widget.onSuccess();
    setState(() {
      _money = '0';
      _notes = '';
    });
  }

  void _addIncome() async {
    if (_notes.isEmpty || double.tryParse(_money) == null || double.tryParse(_money)!.round() <= 0 || _category.isEmpty) {
      _showSnackbar("Please enter valid income, notes, and select a category", Colors.red);
      return;
    }

    // Create a Record object
    final record = RecordModel(
        id: Uuid().v4(),
        date: DateTime.now().toUtc().toIso8601String(),
        amt: double.tryParse(_money)!.round().toDouble(),
        notes: _notes,
        category: _category,
        isIncome: true
    );

    // Use the RecordRepository to add the record
    await _recordRepository.create(record);

    _showSnackbar("Income added successfully!", Colors.green);
    widget.onSuccess();
    setState(() {
      _money = '0';
      _notes = '';
    });
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

  void _openCategoryCreator() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryCreationPage(),
      ),
    );
    fetchCategories();
  }

  void _openCategoryEditor() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryEditorPage(),
      ),
    );
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final double fixedGridHeight = 120.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: CurrencyEditor(money: _money),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                          child: FloatingActionButton(
                            onPressed: _categories.isEmpty ? _openCategoryCreator : _openCategoryEditor,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              _categories.isEmpty ? Icons.add : Icons.edit,
                              color: Colors.blue.shade900,
                            ),
                            mini: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: fixedGridHeight,
                        child: _isLoading
                            ? Center(child: Loading())
                            : CategoryGrid(
                          categories: _categories,
                          onCategorySelected: _onCategorySelected,
                          itemHeight: 320,
                          noOfRows: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: NotesInput(
                          placeholder: 'Add A Note',
                          notes: _notes,
                          onChanged: (value) {
                            setState(() {
                              _notes = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ActionButtons(
                          onAddExpense: _addExpense,
                          onAddIncome: _addIncome,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
