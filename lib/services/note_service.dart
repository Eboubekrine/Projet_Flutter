import 'package:flutter/foundation.dart';
import '../models/note.dart';

// ① Définir les options de tri
enum TriNotes {
  dateRecent,  // Plus récent d'abord (défaut)
  dateAncien,  // Plus ancien d'abord
  titreAZ,     // Alphabétique A → Z
  titreZA,     // Alphabétique Z → A
}

class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];

  // ② Tri courant (défaut : plus récent d'abord)
  TriNotes _tri = TriNotes.dateRecent;
  TriNotes get tri => _tri;

  // ③ Getter notes — retourne la liste TRIÉE selon _tri
  List<Note> get notes {
    final copie = List<Note>.from(_notes); // copie pour ne pas modifier l'original
    switch (_tri) {
      case TriNotes.dateRecent:
        copie.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
      case TriNotes.dateAncien:
        copie.sort((a, b) => a.dateCreation.compareTo(b.dateCreation));
      case TriNotes.titreAZ:
        copie.sort((a, b) => a.titre.compareTo(b.titre));
      case TriNotes.titreZA:
        copie.sort((a, b) => b.titre.compareTo(a.titre));
    }
    return copie;
  }

  int get count => _notes.length;

  void addNote(Note note) { ""
    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(Note noteModifiee) {
    final index = _notes.indexWhere((n) => n.id == noteModifiee.id);
    if (index != -1) {
      _notes[index] = noteModifiee;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  List<Note> search(String query) {
    if (query.trim().isEmpty) return notes;
    final q = query.toLowerCase();
    return notes
        .where((n) =>
            n.titre.toLowerCase().contains(q) ||
            n.contenu.toLowerCase().contains(q))
        .toList();
  }

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  // ④ Changer le tri
  void changerTri(TriNotes nouveauTri) {
    _tri = nouveauTri;
    notifyListeners(); // ← UI se reconstruit avec le nouveau tri
  }
}