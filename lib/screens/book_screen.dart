import 'package:flutter/material.dart';

import '../models/book.dart';
import '../repositories/book_repository.dart';
import '../widgets/book_item.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookRepository _repository = BookRepository();

  Stream<List<Book>>? _booksStream;

  String? _fetchError;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();

    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isFetching = true;
      _fetchError = null;
    });

    try {
      final books = await _repository.getBooks();

      if (!mounted) {
        return;
      }

      setState(() {
        _booksStream = _repository.watchBooks(books);
        _isFetching = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _fetchError = error.toString();
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        actions: [
          IconButton(
            onPressed: _isFetching ? null : _loadBooks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_fetchError != null) {
      return _buildFetchError();
    }

    if (_isFetching || _booksStream == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return StreamBuilder<List<Book>>(
      stream: _booksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return _buildStreamError(snapshot.error);
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No books found'),
          );
        }

        return _buildBookList(snapshot.data!);
      },
    );
  }

  Widget _buildBookList(List<Book> books) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookItem(
          book: books[index],
        );
      },
    );
  }

  Widget _buildFetchError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load books',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _fetchError!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBooks,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamError(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Like stream error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}