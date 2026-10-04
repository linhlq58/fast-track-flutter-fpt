import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      padding: const EdgeInsets.all(16.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Header', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Icon(Icons.notifications),
        ],
      ),
    );
  }
}