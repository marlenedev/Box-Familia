import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';

class RecipesService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection('recipes');

  Stream<List<Recipe>> getRecipes() {

    return _collection.snapshots().map(
      (snapshot) {

        return snapshot.docs.map((doc) {

          return Recipe.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );

        }).toList();
      },
    );
  }

  Future<void> addRecipe(
    Recipe recipe,
  ) async {

    await _collection.add(
      recipe.toFirestore(),
    );
  }

  Future<void> updateRecipe(
  Recipe recipe,
) async {

  await _collection
      .doc(recipe.id)
      .update(
        recipe.toFirestore(),
      );
}

  Future<void> deleteRecipe(
    String id,
  ) async {

    await _collection.doc(id).delete();
  }
}