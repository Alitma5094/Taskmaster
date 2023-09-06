import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateNavigator extends StatefulWidget {
  const DateNavigator(
      {super.key, required this.currentDate, required this.onDateChange});

  final DateTime currentDate;
  final void Function(int difference) onDateChange;

  @override
  State<DateNavigator> createState() => _DateNavigatorState();
}

class _DateNavigatorState extends State<DateNavigator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => widget.onDateChange(-1),
          child: const Icon(Icons.arrow_back),
        ),
        Text(
          DateFormat.MEd().format(widget.currentDate),
        ),
        TextButton(
            onPressed: () => widget.onDateChange(1),
            child: const Icon(Icons.arrow_forward)),
      ],
    );
  }
}
