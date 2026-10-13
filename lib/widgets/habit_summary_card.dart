import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class HabitSummaryCard extends StatelessWidget {
  const HabitSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final completedCount = context.select<HabitProvider, int>(
      (provider) => provider.completedCount,
    );

    final totalCount = context.select<HabitProvider, int>(
      (provider) => provider.totalCount,
    );

    final progress = context.select<HabitProvider, double>(
      (provider) => provider.progress,
    );

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
  }
}