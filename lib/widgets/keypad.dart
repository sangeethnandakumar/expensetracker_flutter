import 'package:flutter/material.dart';
import 'my_key.dart';

class KeyPad extends StatefulWidget {
  final bool allowDecimal;
  final bool allowClear;
  final bool disable;
  final double value;
  final Color seedColor;
  final double? maxAllowed; // Add maxAllowed property
  final Function(String)? onKeyPress;

  KeyPad({
    this.allowDecimal = true,
    this.allowClear = true,
    this.disable = false,
    this.value = 0.0,
    this.seedColor = Colors.green,
    this.maxAllowed, // Initialize maxAllowed
    this.onKeyPress,
  });

  @override
  _KeyPadState createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    // Start with the initial value
    _currentValue = widget.value == 0.0 ? "" : widget.value.toStringAsFixed(1);
  }

  void _handleKeyPress(String value) {
    if (widget.disable) return;

    setState(() {
      if (value == "CLEAR") {
        if (_currentValue.isNotEmpty) {
          _currentValue = _currentValue.substring(0, _currentValue.length - 1);
        }
        if (_currentValue.isEmpty) {
          _currentValue = "0";
        }
      } else if (value == ".") {
        if (!widget.allowDecimal || _currentValue.contains(".")) return;
        _currentValue += value;
      } else {
        // If the current value is "0", reset it to empty before adding a new digit
        if (_currentValue == "0") {
          _currentValue = value;
        } else {
          // Append the new digit only if it doesn't exceed maxAllowed
          String newValueString = _currentValue + value;
          double newValue = double.parse(newValueString);

          // Check if it exceeds maxAllowed and if it maintains valid decimal precision
          if ((widget.maxAllowed == null || newValue <= widget.maxAllowed!) &&
              _validateInput(newValueString)) {
            _currentValue = newValueString;
          }
        }
      }

      // No need to set _currentValue again, just call onKeyPress
      if (widget.onKeyPress != null) {
        widget.onKeyPress!(_currentValue);
      }
    });
  }

  bool _validateInput(String input) {
    final regex = RegExp(r'^\d*\.?\d{0,1}$'); // Matches numbers with at most one decimal point and one decimal place
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyKey(keyName: '1', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '2', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '3', onKeyTap: _handleKeyPress, color: widget.seedColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyKey(keyName: '4', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '5', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '6', onKeyTap: _handleKeyPress, color: widget.seedColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyKey(keyName: '7', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '8', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '9', onKeyTap: _handleKeyPress, color: widget.seedColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.allowClear)
                  MyKey(keyName: 'CLEAR', onKeyTap: _handleKeyPress, color: widget.seedColor),
                MyKey(keyName: '0', onKeyTap: _handleKeyPress, color: widget.seedColor),
                if (widget.allowDecimal)
                  MyKey(keyName: '.', onKeyTap: _handleKeyPress, color: widget.seedColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
