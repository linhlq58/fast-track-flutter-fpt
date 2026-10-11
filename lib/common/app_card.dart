import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {

  final Widget childWigdet;
  final double ?padding;
  
  const AppCard({super.key, required this.childWigdet, this.padding});

  @override
  Widget build(BuildContext context) {
  return Card(
      child: Padding(
        padding: EdgeInsets.all(padding ?? 16.0),
        child: childWigdet,
      ),
    );
  }
}