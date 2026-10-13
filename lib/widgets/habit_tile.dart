import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: ValueKey(habit.id),
        leading: Checkbox(
          value: habit.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            decoration: habit.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          tooltip: 'Remove habit',
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}