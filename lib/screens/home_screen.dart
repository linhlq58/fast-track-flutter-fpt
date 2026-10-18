import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../widgets/add_habit_dialog.dart';
import '../widgets/habit_summary_card.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _showAddHabitDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => AddHabitDialog(
        onAdd: (title) {
          context.read<HabitBloc>().add(HabitAdded(title));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HabitSummaryCard(),
          const SizedBox(height: 24),
          Text('Your habits', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const _HabitList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add habit'),
      ),
    );
  }
}

class _HabitList extends StatelessWidget {
  const _HabitList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      buildWhen: (previous, current) => previous.habits != current.habits,
      builder: (context, state) {
        if (state.habits.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No habits yet. Add your first habit!')),
          );
        }

        return Column(
          children: [
            for (final habit in state.habits)
              HabitTile(
                key: ValueKey(habit.id),
                habit: habit,
                onToggle: () => context
                    .read<HabitBloc>()
                    .add(HabitToggled(habit.id)),
                onRemove: () => context
                    .read<HabitBloc>()
                    .add(HabitRemoved(habit.id)),
              ),
          ],
        );
      },
    );
  }
}
