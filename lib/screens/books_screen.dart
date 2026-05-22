import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/app_user.dart';

import '../services/books_service.dart';

import '../widgets/book_card.dart';
import '../widgets/book_dialog.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../utils/snackbar_helper.dart';

class BooksScreen extends StatefulWidget {
  final AppUser user;

  const BooksScreen({super.key, required this.user});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final BooksService _booksService = BooksService();

  String _selectedFilter = 'all';
  String _searchText = '';

  Future<void> _showAddDialog() async {
    final nameController = TextEditingController();

    final authorController = TextEditingController();

    String selectedType = 'paper';

    await showDialog(
      context: context,

      builder: (_) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Ajouter un livre'),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: nameController,

                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: authorController,

                    decoration: const InputDecoration(labelText: 'Auteur'),
                  ),

                  const SizedBox(height: 16),

                  DropdownButton<String>(
                    value: selectedType,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(
                        value: 'paper',
                        child: Text('Livre papier'),
                      ),

                      DropdownMenuItem(
                        value: 'digital',
                        child: Text('Livre numérique'),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();

                    final author = authorController.text.trim();

                    if (name.isEmpty) {
                      SnackbarHelper.showError(
                        context,
                        'Le nom est obligatoire',
                      );

                      return;
                    }

                    if (author.isEmpty) {
                      SnackbarHelper.showError(
                        context,
                        'L\'auteur est obligatoire',
                      );

                      return;
                    }

                    final book = Book(
                      id: '',
                      name: name,
                      author: author,
                      type: selectedType,
                      ownerId: widget.user.id,
                      ownerName: widget.user.name,
                    );

                    await _booksService.addBook(book);

                    if (!mounted) {
                      return;
                    }

                    SnackbarHelper.showSuccess(context, 'Livre ajouté');

                    Navigator.pop(context);
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(Book book) async {
    final nameController = TextEditingController(text: book.name);

    final authorController = TextEditingController(text: book.author);

    String selectedType = book.type;

    await showDialog(
      context: context,

      builder: (_) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Modifier un livre'),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: nameController,

                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: authorController,

                    decoration: const InputDecoration(labelText: 'Auteur'),
                  ),

                  const SizedBox(height: 16),

                  DropdownButton<String>(
                    value: selectedType,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(
                        value: 'paper',
                        child: Text('Livre papier'),
                      ),

                      DropdownMenuItem(
                        value: 'digital',
                        child: Text('Livre numérique'),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();

                    final author = authorController.text.trim();

                    if (name.isEmpty) {
                      SnackbarHelper.showError(
                        context,
                        'Le nom est obligatoire',
                      );

                      return;
                    }

                    if (author.isEmpty) {
                      SnackbarHelper.showError(
                        context,
                        'L\'auteur est obligatoire',
                      );

                      return;
                    }

                    final updatedBook = Book(
                      id: book.id,
                      name: name,
                      author: author,
                      type: selectedType,
                      ownerId: book.ownerId,
                      ownerName: book.ownerName,
                    );

                    await _booksService.updateBook(updatedBook);

                    if (!mounted) {
                      return;
                    }

                    SnackbarHelper.showSuccess(context, 'Livre modifié');

                    Navigator.pop(context);
                  },
                  child: const Text('Modifier'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livres')),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher un livre ou auteur',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),

            child: DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,

              items: const [
                DropdownMenuItem(value: 'all', child: Text('Tous')),

                DropdownMenuItem(value: 'paper', child: Text('Papier')),

                DropdownMenuItem(value: 'digital', child: Text('Numérique')),
              ],

              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: _booksService.getBooks(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var books = snapshot.data!;

                if (_selectedFilter != 'all') {
                  books = books.where((book) {
                    return book.type == _selectedFilter;
                  }).toList();
                }
                if (_searchText.isNotEmpty) {
                  books = books.where((book) {
                    final name = book.name.toLowerCase();

                    final author = book.author.toLowerCase();

                    return name.contains(_searchText) ||
                        author.contains(_searchText);
                  }).toList();
                }

                if (books.isEmpty) {
                  return const Center(child: Text('Aucun livre'));
                }

                return ListView.builder(
                  itemCount: books.length,

                  itemBuilder: (context, index) {
                    final book = books[index];

                    final isOwner = book.ownerId == widget.user.id;

                    return BookCard(
                      book: book,
                      isOwner: isOwner,

                      onEdit: () {
                        _showEditDialog(book);
                      },

                      onDelete: () async {
                        showDialog(
                          context: context,

                          builder: (_) {
                            return ConfirmDeleteDialog(
                              title: "Suppression du livre : ${book.name}",

                              message: 'Voulez-vous supprimer ce livre ?',

                              onConfirm: () async {
                                await _booksService.deleteBook(book.id);
                              },
                            );
                          },
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
