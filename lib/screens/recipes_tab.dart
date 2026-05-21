import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../models/app_user.dart';

import '../services/recipes_service.dart';

class RecipesTab extends StatefulWidget {
  final AppUser user;

  const RecipesTab({super.key, required this.user});

  @override
  State<RecipesTab> createState() => _RecipesTabState();
}

class _RecipesTabState extends State<RecipesTab> {
  final RecipesService _service = RecipesService();

  String _selectedFilter = 'all';

  Future<void> _showAddDialog() async {
    final nameController = TextEditingController();

    String selectedType = 'savory';

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter recette'),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),

                  const SizedBox(height: 16),

                  DropdownButton<String>(
                    value: selectedType,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(value: 'savory', child: Text('Salé')),

                      DropdownMenuItem(value: 'sweet', child: Text('Sucré')),
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
                    final recipe = Recipe(
                      id: '',
                      name: nameController.text,
                      type: selectedType,
                      ownerId: widget.user.id,
                      ownerName: widget.user.name,
                    );

                    await _service.addRecipe(recipe);

                    if (!mounted) {
                      return;
                    }

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

  Future<void> _showEditDialog(Recipe recipe) async {
    final nameController = TextEditingController(text: recipe.name);

    String selectedType = recipe.type;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Modifier recette'),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),

                  const SizedBox(height: 16),

                  DropdownButton<String>(
                    value: selectedType,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(value: 'savory', child: Text('Salé')),

                      DropdownMenuItem(value: 'sweet', child: Text('Sucré')),
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
                    final updatedRecipe = Recipe(
                      id: recipe.id,
                      name: nameController.text,
                      type: selectedType,
                      ownerId: recipe.ownerId,
                      ownerName: recipe.ownerName,
                    );

                    await _service.updateRecipe(updatedRecipe);

                    if (!mounted) {
                      return;
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Sauvegarder'),
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
      appBar: AppBar(title: const Text('Recettes')),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),

            child: DropdownButton<String>(
              value: _selectedFilter,

              isExpanded: true,

              items: const [
                DropdownMenuItem(value: 'all', child: Text('Toutes')),

                DropdownMenuItem(value: 'savory', child: Text('Salées')),

                DropdownMenuItem(value: 'sweet', child: Text('Sucrées')),
              ],

              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Recipe>>(
              stream: _service.getRecipes(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var recipes = snapshot.data!;

                if (_selectedFilter != 'all') {
                  recipes = recipes.where((recipe) {
                    return recipe.type == _selectedFilter;
                  }).toList();
                }

                if (recipes.isEmpty) {
                  return const Center(child: Text('Aucune recette'));
                }

                return ListView.builder(
                  itemCount: recipes.length,

                  itemBuilder: (context, index) {
                    final recipe = recipes[index];

                    final isOwner = recipe.ownerId == widget.user.id;

                    return Card(
                      margin: const EdgeInsets.all(8),

                      child: ListTile(
                        leading: Icon(
                          recipe.type == 'sweet'
                              ? Icons.cake
                              : Icons.restaurant,
                        ),

                        title: Text(recipe.name),

                        subtitle: Text('Propriétaire : ${recipe.ownerName}'),

                        trailing: isOwner
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditDialog(recipe);
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await _service.deleteRecipe(recipe.id);
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
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
