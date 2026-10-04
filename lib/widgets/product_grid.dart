import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              shadowColor: Colors.black.withValues(alpha: 1),
              color: Colors.yellowAccent,
              child: Center(
                child: Text('Product ${index + 1}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            );
          },
        ),
      ),
    );
  }
}