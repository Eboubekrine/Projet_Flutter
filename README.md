📒 Bloc-Notes Flutter
Application mobile de prise de notes développée avec Flutter dans le cadre d'un TP universitaire.

👥 Équipe
Matricule240442404324038

📱 Fonctionnalités

✅ Créer, lire, modifier et supprimer des notes (CRUD complet)
🎨 Choisir une couleur pour chaque note
🔍 Rechercher une note par titre ou contenu
🔃 Trier les notes (date, titre A→Z, titre Z→A)
📅 Affichage de la date de création et modification


🗂️ Structure du projet
lib/
├── main.dart
├── models/
│   └── note.dart
├── pages/
│   ├── home_page.dart       # Partie 1 — setState
│   ├── home_page_v2.dart    # Partie 2 — Provider
│   ├── create_page.dart
│   └── detail_page.dart
└── services/
    └── note_service.dart    # Partie 2 — Provider

🔀 Différence entre setState et Provider
setState — Partie 1
L'état vit dans un seul widget. Les autres pages n'y ont pas accès directement.
HomePage
└── _notes = [...]   ← données stockées ICI seulement
    ├── CreatePage   ← ne voit pas _notes ❌
    └── DetailPage   ← ne voit pas _notes ❌
Pour partager des données entre pages, on est obligé de les passer manuellement via Navigator.push et Navigator.pop :
dart// Envoyer une note
Navigator.push(context, MaterialPageRoute(
  builder: (_) => DetailPage(note: note), // ← passage manuel
));

// Récupérer le résultat
final resultat = await Navigator.push(...);
setState(() { _notes.add(resultat); }); // ← mise à jour manuelle

Provider — Partie 2
L'état vit dans un service séparé. Toutes les pages y accèdent librement et automatiquement.
NoteService
└── _notes = [...]   ← données accessibles partout
    ├── HomePage     ← accès direct ✅
    ├── CreatePage   ← accès direct ✅
    └── DetailPage   ← accès direct ✅
Plus besoin de passer les données à la main :
dart// Ajouter depuis n'importe quelle page
context.read<NoteService>().addNote(note); // ✅ direct

// Lire depuis n'importe quelle page
context.watch<NoteService>().notes // ✅ automatique

Tableau comparatif
CritèresetStateProviderOù vivent les donnéesDans un widgetDans un service séparéAccès depuis une autre page❌ Impossible directement✅ PartoutMise à jour de l'UIsetState() manuelnotifyListeners() automatiquePartage de donnéesVia push/pop à la mainAutomatiqueLogique métierMélangée dans l'UISéparée dans le serviceIdéal pourPetites apps / un écranApps avec plusieurs écrans

Comparaison ligne par ligne
ActionPartie 1 — setStatePartie 2 — ProviderAjoutersetState(() { _notes.add(note); })context.read<NoteService>().addNote(note)SupprimersetState(() { _notes.removeAt(i); })context.read<NoteService>().deleteNote(id)ModifiersetState(() { _notes[i] = note; })context.read<NoteService>().updateNote(note)Lire_notescontext.watch<NoteService>().notes

🎯 Avantages du TP
Avantages pédagogiques

Progression logique — on commence par setState (simple) avant d'introduire Provider (architecture), ce qui permet de comprendre pourquoi on a besoin du Provider
Comparaison directe — refactoriser la même app avec deux approches différentes ancre la différence de manière concrète
CRUD complet — le TP couvre toutes les opérations de base (Create, Read, Update, Delete) que l'on retrouve dans toute vraie application
Navigation multi-écrans — on apprend à passer des données entre pages avec push/pop et à interpréter les résultats retournés

Avantages techniques

Séparation des responsabilités — avec Provider, la logique métier est dans NoteService et l'UI dans les pages, ce qui rend le code plus lisible et maintenable
Réutilisabilité — create_page.dart et detail_page.dart sont identiques entre les deux parties, ce qui montre qu'une bonne architecture ne casse pas l'existant
Scalabilité — l'architecture Provider facilite l'ajout de nouvelles fonctionnalités (recherche, tri) sans modifier les pages existantes
Bonnes pratiques Flutter — dispose() sur les contrôleurs, context.mounted après les await, copyWith() pour l'immuabilité


🚀 Lancer le projet
bash# Cloner le repo
git clone https://github.com/votre-repo/bloc-notes-flutter.git

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

🛠️ Technologies utilisées

Flutter — Framework UI
Provider — Gestion d'état (Partie 2)
Dart — Langage de programmation