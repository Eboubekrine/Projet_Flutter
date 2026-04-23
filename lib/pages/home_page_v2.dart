import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../models/note.dart';
import 'create_page.dart';
import 'detail_page.dart';

// ← StatefulWidget uniquement pour gérer _query (recherche locale)
// Tout le reste vient du NoteService
class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  // Seul état local : la barre de recherche
  String _query = '';
  final TextEditingController _searchController = TextEditingController();
  bool _afficherRecherche = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ouvrirCreation() async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );
    if (note != null && mounted) {
      // context.read → accès sans abonnement, utilisé dans les callbacks
      context.read<NoteService>().addNote(note);
      // Plus besoin de setState ! notifyListeners() s'en charge
    }
  }

  Future<void> _ouvrirDetail(Note note) async {
    final resultat = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => DetailNotePage(note: note)),
    );

    if (!mounted) return;

    if (resultat == 'deleted') {
      context.read<NoteService>().deleteNote(note.id);
    } else if (resultat is Note) {
      context.read<NoteService>().updateNote(resultat);
    }
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // context.watch → abonnement, se reconstruit quand notifyListeners() est appelé
    final service = context.watch<NoteService>();
    final notes = _query.isEmpty ? service.notes : service.search(_query);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        title: _afficherRecherche
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Rechercher une note…',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _query = val),
              )
            : Row(
                children: [
                  const Text('Mes Notes'),
                  const SizedBox(width: 8),

                  // Consumer ciblé → reconstruit UNIQUEMENT le badge
                  // sans reconstruire toute la page
                  Consumer<NoteService>(
                    builder: (_, svc, __) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${svc.count}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
        actions: [
          // Bouton recherche
          IconButton(
            icon: Icon(_afficherRecherche ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _afficherRecherche = !_afficherRecherche;
                if (!_afficherRecherche) {
                  _query = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    _query.isEmpty ? 'Aucune note' : 'Aucun résultat',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final couleur = _hexToColor(note.couleur);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () => _ouvrirDetail(note),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: couleur, width: 5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.titre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.contenu.length > 30
                                ? '${note.contenu.substring(0, 30)}…'
                                : note.contenu,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(note.dateCreation),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirCreation,
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}