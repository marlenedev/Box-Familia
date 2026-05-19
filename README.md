# Box Familia

Projet Flutter MVP avec :

- Drift / SQLite local
- Table `utilisateurs`
- Suppression logique avec `deletedAt`
- Métadonnées de synchronisation : `updatedAt`, `version`, `deviceId`, `needsSync`
- Moteur de synchronisation MVP
- Stockage local temporaire pour tester la sync sans Google Drive
- Classe `GoogleDriveSyncStorage` préparée pour la prochaine étape

## Commandes à lancer

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Important

Le fichier généré `lib/db/app_database.g.dart` n'est pas inclus volontairement.
Il est généré par Drift avec la commande `build_runner`.

## Architecture ajoutée

```txt
lib/
 ├─ app/
 │   └─ app.dart
 ├─ db/
 │   └─ app_database.dart
 ├─ features/
 │   └─ users/
 │       ├─ data/
 │       │   └─ user_repository.dart
 │       └─ domain/
 │           └─ user_form_data.dart
 ├─ sync/
 │   ├─ google_drive_sync_storage.dart
 │   ├─ local_file_sync_storage.dart
 │   ├─ sync_change.dart
 │   ├─ sync_service.dart
 │   └─ sync_storage.dart
 └─ main.dart
```

## Stratégie de synchronisation MVP

Pour le MVP, la règle de conflit est :

```txt
Last Write Wins
```

Donc la ligne avec le `updatedAt` le plus récent gagne.

Plus tard, on pourra remplacer cette règle par :

- fusion champ par champ
- écran de résolution de conflit
- historique de changements
- vraie implémentation Google Drive `appDataFolder`
