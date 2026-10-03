import 'package:flutter/material.dart';

import '../widgets/hobby_information_card.dart';
import '../widgets/main_information_card.dart';
import '../widgets/my_post_card.dart';
import '../widgets/other_information_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          MainInformationCard(
            name: 'Finn Vu',
            description: 'Junior Software Engineer',
          ),

          SizedBox(height: 12),

          OtherInformationCard(
            school: 'UTC',
            company: 'FPT Software',
            role: 'Mobile Developer',
          ),

          SizedBox(height: 12),

          HobbyInformationCard(
            hobbies: [
              'Reading',
              'Coding',
              'Traveling'
            ],
          ),

          SizedBox(height: 12),

          MyPostCard(
            content: 'Just finished reading a new book: Silo #1 📚',
            initialLikeCount: 10,
          ),
        ],
      ),
    );
  }
}