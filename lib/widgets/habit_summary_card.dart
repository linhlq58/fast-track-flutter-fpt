import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/habit_bloc.dart';
import '../bloc/habit_state.dart';

class HabitSummaryCard extends StatelessWidget {
  const HabitSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HabitBloc, HabitState, (int, int, double)>(
      selector: (state) => (
        state.completedCount,
        state.totalCount,
        state.progress,
      ),
      builder: (context, summary) {
        final (completedCount, totalCount, progress) = summary;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's progress",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '$completedCount of $totalCount completed',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Text('${(progress * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress),
              ],
            ),
          ),
        );
      },
    );
  }
}
