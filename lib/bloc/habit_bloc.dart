import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/habit.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc()
      : super(
          const HabitState(
            habits: [
              Habit(id: '1', title: 'Read a book'),
              Habit(id: '2', title: 'Exercise for 30 minutes'),
              Habit(id: '3', title: 'Learn Flutter for 1 hour'),
              Habit(id: '4', title: 'Meditate for 10 minutes'),
              Habit(id: '5', title: 'Drink 8 glasses of water'),
            ],
          ),
        ) {
    on<HabitAdded>(_onHabitAdded);
    on<HabitToggled>(_onHabitToggled);
    on<HabitRemoved>(_onHabitRemoved);
  }

  void _onHabitAdded(HabitAdded event, Emitter<HabitState> emit) {
    final title = event.title.trim();
    if (title.isEmpty) return;

    final habit = Habit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );

    emit(HabitState(habits: List.unmodifiable([...state.habits, habit])));
  }

  void _onHabitToggled(HabitToggled event, Emitter<HabitState> emit) {
    final exists = state.habits.any((habit) => habit.id == event.id);
    if (!exists) return;

    final updatedHabits = state.habits.map((habit) {
      if (habit.id == event.id) {
        return habit.copyWith(isCompleted: !habit.isCompleted);
      }
      return habit;
    }).toList(growable: false);

    emit(HabitState(habits: List.unmodifiable(updatedHabits)));
  }

  void _onHabitRemoved(HabitRemoved event, Emitter<HabitState> emit) {
    final updatedHabits = state.habits
        .where((habit) => habit.id != event.id)
        .toList(growable: false);

    if (updatedHabits.length == state.habits.length) return;
    emit(HabitState(habits: List.unmodifiable(updatedHabits)));
  }
}
