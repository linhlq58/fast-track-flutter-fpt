import 'package:flutter/material.dart';

class OtherInformationCard extends StatelessWidget {
  final String school;
  final String company;
  final String role;

  const OtherInformationCard({
    super.key,
    required this.school,
    required this.company,
    required this.role,
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
              'Other Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.school,
              title: 'School',
              value: school,
            ),
            _InfoRow(
              icon: Icons.business,
              title: 'Company',
              value: company,
            ),
            _InfoRow(
              icon: Icons.work,
              title: 'Role',
              value: role,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}