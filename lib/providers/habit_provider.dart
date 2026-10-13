import 'package:flutter/material.dart';
import 'package:fast_track_flutter_fpt/models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [
    const Habit(id: '1', title: 'Read a book'),
    const Habit(id: '2', title: 'Exercise for 30 minutes'),
    const Habit(id: '3', title: 'Lean Flutter for 1 hour'),
    const Habit(id: '4', title: 'Meditate for 10 minutes'),
    const Habit(id: '5', title: 'Drink 8 glasses of water'),
  ];

  List<Habit> get habits => List.unmodifiable(_habits);

  int get totalCount => _habits.length;

  int get completedCount => _habits.where((habits) => habits.isCompleted).length;

  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  void addHabit(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    Habit habit = Habit(id: DateTime.now().microsecondsSinceEpoch.toString(), title: trimmedTitle);

    _habits.add(habit);
    notifyListeners();
  }

  void toggleHabit(String id) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    
    if (index != -1) {
      _habits[index] = _habits[index].copyWith(isCompleted: !_habits[index].isCompleted);
      notifyListeners();
    }
  }

  void removeHabit(String id) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    if (index != -1) {
      _habits.removeAt(index);
      notifyListeners();
    }
  }

}