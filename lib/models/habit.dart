class Habit {
  final String id;
  final String title;
  final bool isCompleted;

  const Habit({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Habit copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}