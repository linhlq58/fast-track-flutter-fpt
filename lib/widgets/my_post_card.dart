import 'package:flutter/material.dart';

class MyPostCard extends StatefulWidget {
  final String content;
  final int initialLikeCount;

  const MyPostCard({
    super.key,
    required this.content,
    this.initialLikeCount = 0,
  });

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard> {
  late int _likeCount;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();

    _likeCount = widget.initialLikeCount;

    debugPrint('MyPostCard: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    debugPrint('MyPostCard: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MyPostCard: build');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Post',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(widget.content),

            const SizedBox(height: 16),

            Row(
              children: [
                Icon(
                  _isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _isLiked ? Colors.red : null,
                ),

                const SizedBox(width: 8),

                Text(
                  '$_likeCount likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                TextButton.icon(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: Text(
                    _isLiked ? 'Liked' : 'Like',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likeCount--;
        _isLiked = false;
      } else {
        _likeCount++;
        _isLiked = true;
      }
    });

    debugPrint(
      'MyPostCard: like count = $_likeCount',
    );
  }

  @override
  void deactivate() {
    debugPrint('MyPostCard: deactivate');

    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('MyPostCard: dispose');

    super.dispose();
  }
}