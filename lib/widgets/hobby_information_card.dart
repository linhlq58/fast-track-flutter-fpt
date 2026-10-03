import 'package:flutter/material.dart';

class HobbyInformationCard extends StatelessWidget {
  final List<String> hobbies;

  const HobbyInformationCard({
    super.key,
    required this.hobbies,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hobbies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hobbies.map((hobby) {
                return Chip(
                  avatar: const Icon(
                    Icons.favorite_outline,
                    size: 18,
                  ),
                  label: Text(hobby),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}