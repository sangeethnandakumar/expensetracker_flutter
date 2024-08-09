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
  final VoidCallback onSuccess;

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
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    final allCategories = await _categoryRepository.getAll();
    setState(() {
      _categories = allCategories;
      _category = allCategories.isNotEmpty ? allCategories[0].id : '';
      _isLoading = false;
    });
  }

  void _updateMoney(String value) => setState(() => _money = value);
  void _updateNotes(String value) => setState(() => _notes = value);
  void _updateCategory(String value) => setState(() => _category = value);

  Future<void> _addRecord(bool isIncome) async {
    if (!_validateInput()) return;

    final record = _createRecordModel(isIncome);
    await _recordRepository.create(record);
    _handleSuccessfulAdd(isIncome);
  }

  bool _validateInput() {
    final amount = double.tryParse(_money);
    if (_notes.isEmpty || amount == null || amount <= 0 || _category.isEmpty) {
      _showSnackbar("Please enter valid amount, notes, and select a category", Colors.red);
      return false;
    }
    return true;
  }

  RecordModel _createRecordModel(bool isIncome) {
    return RecordModel(
        id: const Uuid().v4(),
        date: DateTime.now().toUtc().toIso8601String(),
        amt: isIncome ? double.parse(_money) : -double.parse(_money),
        notes: _notes,
        category: _category,
        isIncome: isIncome
    );
  }

  void _handleSuccessfulAdd(bool isIncome) {
    _showSnackbar("${isIncome ? 'Income' : 'Expense'} added successfully!", Colors.green);
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openCategoryManager() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _categories.isEmpty ? const CategoryCreationPage() : CategoryEditorPage(),
      ),
    );
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildCurrencyEditor(),
                    _buildCategoryManagerButton(),
                    _buildCategoryGrid(),
                    _buildNotesInput(),
                    _buildActionButtons(),
                    _buildKeypad(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyEditor() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: CurrencyEditor(money: _money),
  );

  Widget _buildCategoryManagerButton() => Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
      child: FloatingActionButton(
        onPressed: _openCategoryManager,
        backgroundColor: Colors.blue.shade100,
        child: Icon(
          _categories.isEmpty ? Icons.add : Icons.edit,
          color: Colors.blue.shade900,
        ),
        mini: true,
      ),
    ),
  );

  Widget _buildCategoryGrid() => SizedBox(
    height: 120.0,
    child: _isLoading
        ? Center(child: Loading())
        : CategoryGrid(
      categories: _categories,
      onCategorySelected: _updateCategory,
      itemHeight: 320,
      noOfRows: 1,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    ),
  );

  Widget _buildNotesInput() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: NotesInput(
      placeholder: 'Add A Note',
      notes: _notes,
      onChanged: _updateNotes,
    ),
  );

  Widget _buildActionButtons() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: ActionButtons(
      onAddExpense: () => _addRecord(false),
      onAddIncome: () => _addRecord(true),
    ),
  );

  Widget _buildKeypad() => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: KeyPad(
        allowDecimal: true,
        allowClear: true,
        disable: false,
        maxAllowed: 100000,
        value: double.tryParse(_money) ?? 0.0,
        seedColor: Colors.blue.shade100,
        onKeyPress: _updateMoney,
      ),
    ),
  );
}