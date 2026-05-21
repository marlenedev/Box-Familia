import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';

class BooksService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference get _booksCollection =>
      _firestore.collection('books');

  Stream<List<Book>> getBooks() {

    return _booksCollection.snapshots().map(
      (snapshot) {

        return snapshot.docs.map((doc) {

          return Book.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );

        }).toList();
      },
    );
  }

  Future<void> addBook(Book book) async {

    await _booksCollection.add(
      book.toFirestore(),
    );
  }

  Future<void> updateBook(Book book) async {

    await _booksCollection
        .doc(book.id)
        .update(
          book.toFirestore(),
        );
  }

  Future<void> deleteBook(
    String bookId,
  ) async {

    await _booksCollection
        .doc(bookId)
        .delete();
  }
}