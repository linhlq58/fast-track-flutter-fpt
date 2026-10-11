import 'package:fast_track_flutter_fpt/common/app_card.dart';
import 'package:flutter/material.dart';

class MainInformationCard extends StatelessWidget {

  final String name;
  final String description;

  const MainInformationCard({super.key, required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    debugPrint('MainInformationCard: build');
    return AppCard(
      padding: 20,
      childWigdet: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}