class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final int likeCount;

  Book({
    required this.id, 
    required this.title, 
    required this.author, 
    required this.year,
    required this.likeCount
  });

  Book.empty() : id = 0, title = 'Untitled', author = 'N/A', year = 0, likeCount = 0;

  Book copyWith({
    int? id,
    String? title,
    String? author,
    int? year,
    int? likeCount,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
