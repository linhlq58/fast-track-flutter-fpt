import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/summer.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            ),
            alignment: Alignment.center,
                  child: const Text(
                    'Summer Collection',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
      
          Positioned(
            top: 8,
            right: 8,
            child: Chip(
              backgroundColor: Colors.yellowAccent,
              label: Text('SALE', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ]
      ),
    );
  }
}