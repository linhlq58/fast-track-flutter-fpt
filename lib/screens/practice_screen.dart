import 'package:flutter/material.dart';
import 'package:fast_track_flutter_fpt/widgets/header_widget.dart';
import 'package:fast_track_flutter_fpt/widgets/banner_widget.dart';
import 'package:fast_track_flutter_fpt/widgets/product_grid.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            BannerWidget(),
            ProductGrid(),
          ],
        ),
      ),
    );
  }
}