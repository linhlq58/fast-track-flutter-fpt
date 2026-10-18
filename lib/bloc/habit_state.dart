import 'package:equatable/equatable.dart';

import '../models/habit.dart';

class HabitState extends Equatable {
  final List<Habit> habits;

  const HabitState({this.habits = const []});

  int get totalCount => habits.length;

  int get completedCount => habits.where((habit) => habit.isCompleted).length;

  double get progress =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  @override
  List<Object?> get props => [habits];
}
