import 'package:flutter/material.dart';
import '../models/CategoryModel.dart';
import '../models/record.dart';
import '../widgets/currencyeditor.dart';
import '../api.dart';
import 'package:intl/intl.dart';
import '../widgets/daybar.dart';
import '../widgets/empty_state.dart';
import '../widgets/records_list.dart';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<Record> _records = [];
  Map<String, CategoryModel> _categories = {};
  bool _isLoading = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();
  double _totalExp = 0.0;

  final int _daysRange = 6;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second));
    _endDate = DateTime.now().add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
    _selectedDate = _startDate;

    Future.wait([
      _fetchCategories(),
      _fetchRecords(_startDate, _endDate)
    ]).then((_) {
      setState(() {
        // Update the UI if needed
      });
    }).catchError((error) {
      print('Error fetching data: $error');
      // Handle any errors that occurred during the API calls
    });
  }

  Future<void> _fetchCategories() async {
    try {
      await Api.get('/categories', (data) {
        setState(() {
          _categories = Map.fromEntries((data as List)
              .map((json) => CategoryModel.fromJson(json))
              .map((category) => MapEntry(category.id, category)));
        });
      }, (error) {
        print('Error fetching categories: $error');
      });
    } catch (e) {
      print('Exception while fetching categories: $e');
    }
  }

  Future<void> _fetchRecords(DateTime startDate, DateTime endDate) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String start = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(startDate.toUtc());
    String end = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(endDate.toUtc());

    String endpoint = '/tracks?start=$start&end=$end';

    return Api.get(endpoint, (data) {
      setState(() {
        _records = (data as List).map((json) => Record.fromJson(json)).toList();
        _totalExp = _records.fold(0.0, (sum, record) => sum + record.exp);
        _isLoading = false;
      });
    }, (error) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    });
  }

  void _showOptionsBottomSheet(String recordId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  await _deleteRecord(recordId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteRecord(String recordId) async {
    String endpoint = '/tracks/$recordId';

    try {
      await Api.delete(
        endpoint,
            (data) {
          setState(() {
            _records.removeWhere((record) => record.id == recordId);
            _totalExp = _records.fold(0.0, (sum, record) => sum + record.exp);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record deleted successfully.')));
        },
            (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _fetchRecords(_startDate, _endDate);
      });
    }
  }

  void _onDayBarTap(DateTime date) {
    setState(() {
      _startDate = DateTime(date.year, date.month, date.day);
      _endDate = _startDate.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
      _selectedDate = _startDate;
      _fetchRecords(_startDate, _endDate);
    });
  }

  void _changeDate(int delta) {
    DateTime newDate = _selectedDate.add(Duration(days: delta));
    if (newDate.isBefore(DateTime.now().subtract(Duration(days: _daysRange))) || newDate.isAfter(DateTime.now())) {
      return; // Do not allow date changes outside the defined range
    }

    setState(() {
      _selectedDate = newDate;
      _startDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      _endDate = _startDate.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
      _fetchRecords(_startDate, _endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dayBars = [];
    for (int i = 0; i <= _daysRange; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      dayBars.add(GestureDetector(
        onTap: () => _onDayBarTap(date),
        child: DayBar(
          date: date,
          isSelected: date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day,
        ),
      ));
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _changeDate(1);
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          _changeDate(-1);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: dayBars),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: Icon(Icons.calendar_today),
                    label: Text('Select Start Date'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: Icon(Icons.calendar_today),
                    label: Text('Select End Date'),
                  ),
                ],
              ),
            ),
            if (_totalExp > 0)
              CurrencyEditor(
                money: _totalExp.round().toString(),
                fontSize: 80,
                textColor: Colors.redAccent.shade100,
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _fetchRecords(_startDate, _endDate);
                },
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    } else if (_records.isEmpty) {
      return EmptyState();
    } else {
      return RecordsList(
        records: _records,
        onLongPress: _showOptionsBottomSheet,
        getCategory: (categoryId) => _categories[categoryId],
      );
    }
  }
}