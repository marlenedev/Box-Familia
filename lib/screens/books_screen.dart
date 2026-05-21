import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/app_user.dart';

import '../services/books_service.dart';

import '../widgets/book_card.dart';
import '../widgets/book_dialog.dart';

class BooksScreen extends StatefulWidget {

  final AppUser user;

  const BooksScreen({
    super.key,
    required this.user,
  });

  @override
  State<BooksScreen> createState() =>
      _BooksScreenState();
}

class _BooksScreenState
    extends State<BooksScreen> {

  final BooksService _booksService =
      BooksService();

  String _selectedFilter = 'all';
  String _searchText = '';

  Future<void> _showAddDialog() async {

    final nameController =
        TextEditingController();

    final authorController =
        TextEditingController();

    String selectedType = 'paper';

    await showDialog(
      context: context,
      builder: (_) {

        return StatefulBuilder(
          builder: (context, setState) {

            return BookDialog(
              title: 'Ajouter un livre',
              buttonText: 'Ajouter',

              nameController:
                  nameController,

              authorController:
                  authorController,

              selectedType:
                  selectedType,

              onTypeChanged: (value) {

                setState(() {
                  selectedType =
                      value!;
                });
              },

              onConfirm: () async {

                final book = Book(
                  id: '',
                  name:
                      nameController.text,
                  author:
                      authorController.text,
                  type: selectedType,
                  ownerId:
                      widget.user.id,
                  ownerName:
                      widget.user.name,
                );

                await _booksService
                    .addBook(book);

                if (!mounted) return;

                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Livres'),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 8,
  ),

  child: TextField(
    decoration: const InputDecoration(
      hintText:
          'Rechercher un livre ou auteur',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(),
    ),

    onChanged: (value) {

      setState(() {
        _searchText =
            value.toLowerCase();
      });
    },
  ),
),

          Padding(
            padding:
                const EdgeInsets.all(8),

            child: DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,

              items: const [

                DropdownMenuItem(
                  value: 'all',
                  child: Text('Tous'),
                ),

                DropdownMenuItem(
                  value: 'paper',
                  child:
                      Text('Papier'),
                ),

                DropdownMenuItem(
                  value: 'digital',
                  child:
                      Text('Numérique'),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  _selectedFilter =
                      value!;
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Book>>(
              stream:
                  _booksService.getBooks(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                var books =
                    snapshot.data!;

                if (_selectedFilter !=
                    'all') {

                  books = books.where(
                    (book) {

                      return book.type ==
                          _selectedFilter;
                    },
                  ).toList();
                }
                if (_searchText.isNotEmpty) {

  books = books.where((book) {

    final name =
        book.name.toLowerCase();

    final author =
        book.author.toLowerCase();

    return name.contains(_searchText) ||
        author.contains(_searchText);

  }).toList();
}

                if (books.isEmpty) {
                  return const Center(
                    child:
                        Text('Aucun livre'),
                  );
                }

                return ListView.builder(
                  itemCount:
                      books.length,

                  itemBuilder:
                      (context, index) {

                    final book =
                        books[index];

                    final isOwner =
                        book.ownerId ==
                            widget.user.id;

                    return BookCard(
                      book: book,
                      isOwner: isOwner,

                      onEdit: () {},

                      onDelete: () async {

                        await _booksService
                            .deleteBook(
                          book.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}