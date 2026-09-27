import '../models/book.dart';

class BookRepository {

  Future<List<Book>> getBooks() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 2));
    
    return [
      Book(id: 1, title: '1984', author: 'George Orwell', year: 1949, likeCount: 15),
      Book(id: 2, title: 'To Kill a Mockingbird', author: 'Harper Lee', year: 1960, likeCount: 10),
      Book(id: 3, title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', year: 1925, likeCount: 25),
      Book(id: 4, title: 'Wool - The Silo #1', author: 'Huge Howey', year: 2021, likeCount: 36),
      Book(id: 5, title: 'The Catcher in the Rye', author: 'J.D. Salinger', year: 1951, likeCount: 50),
      Book(id: 6, title: 'Clean Code', author: 'Robert C. Martin', year: 2008, likeCount: 120),
    ];
  }

  Stream<List<Book>> watchBooks(
    List<Book> initialBooks,
  ) async* {
    var books = initialBooks;

    // Emit initial state.
    yield books;

    // Book 1 gets a like.
    await Future.delayed(const Duration(seconds: 2),);
    books = books.map((book) {
      if (book.id == 1) {
        return book.copyWith(
          likeCount: book.likeCount + 1,
        );
      }
      return book;
    }).toList();

    yield books;

    // Book 2 gets a like.
    await Future.delayed(const Duration(seconds: 2),);
    books = books.map((book) {
      if (book.id == 2) {
        return book.copyWith(
          likeCount: book.likeCount + 1,
        );
      }
      return book;
    }).toList();

    yield books;

    // Book 1 gets two more likes.
    await Future.delayed(const Duration(seconds: 2),);
    books = books.map((book) {
      if (book.id == 1) {
        return book.copyWith(
          likeCount: book.likeCount + 2,
        );
      }
      return book;
    }).toList();

    yield books;

    // Book 3 gets a like.
    await Future.delayed(const Duration(seconds: 2),);
    books = books.map((book) {
      if (book.id == 3) {
        return book.copyWith(
          likeCount: book.likeCount + 1,
        );
      }
      return book;
    }).toList();
  }

}