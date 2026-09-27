import 'package:flutter/material.dart';
import '../models/book.dart';

class BookItem extends StatefulWidget {
  final Book book;

  const BookItem({
    super.key,
    required this.book,
  });
  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> with SingleTickerProviderStateMixin {
  Book get book => widget.book;

  late final AnimationController _likeAnimationController;

  late final Animation<double> _likeScaleAnimation;
  late final Animation<Color?> _likeColor;

   @override
  void initState() {
    super.initState();

    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _likeScaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 1.35,
          ),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.35,
            end: 1.0,
          ),
          weight: 60,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Grey → Red → Grey
    _likeColor = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.grey,
            end: Colors.red,
          ),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.red,
            end: Colors.grey,
          ),
          weight: 60,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant BookItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldLikeCount = oldWidget.book.likeCount;
    final newLikeCount = widget.book.likeCount;

    // Play animation only when the like count increases.
    if (newLikeCount > oldLikeCount) {
      _likeAnimationController.forward(from: 0);
    }
  }

   @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${book.id}'),
        ),
        title: Text(
          book.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        subtitle: Text(
          '${book.author} • ${book.year}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _likeAnimationController,
              builder:(context, child) {
                return Transform.scale(
                  scale: _likeScaleAnimation.value,
                  child: Icon(
                    Icons.favorite,
                    size: 20,
                    color: _likeColor.value,
                  ),
                );
              },
            ),
            const SizedBox(width: 4), 
              Text(
                '${book.likeCount}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}