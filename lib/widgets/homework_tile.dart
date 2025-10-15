import 'package:flutter/material.dart';
import '../models/homework.dart';
import 'package:intl/intl.dart';

class HomeworkTile extends StatelessWidget {
  final Homework item;
  final VoidCallback onToggle;

  const HomeworkTile({Key? key, required this.item, required this.onToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(item.dueDate);
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(
          decoration:
          item.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Text('${item.subject} • Due: $formattedDate'),
      trailing: Checkbox(
        value: item.isCompleted,
        onChanged: (_) => onToggle(),
      ),
    );
  }
}
