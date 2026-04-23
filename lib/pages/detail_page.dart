import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailNotePage extends StatelessWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  String _formatDateComplete(DateTime date) {
    const mois = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${mois[date.month]} ${date.year} à $h:$m';
  }

  Future<void> _confirmerSuppression(BuildContext context) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette note ?'),
        content: const Text(
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirme == true && context.mounted) {
      Navigator.pop(context, 'deleted');
    }
  }

  Future<void> _modifierNote(BuildContext context) async {
    final noteModifiee = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateNotePage(note: note),
      ),
    );

    if (noteModifiee != null && context.mounted) {
      Navigator.pop(context, noteModifiee);
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleur = _hexToColor(note.couleur);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleur,
        foregroundColor: Colors.black87,
        title: const Text('Détail Note'),
        actions: [
          IconButton(
            onPressed: () => _modifierNote(context),
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
          ),
          IconButton(
            onPressed: () => _confirmerSuppression(context),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Supprimer',
            color: Colors.red[700],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.titre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  'Créée le ${_formatDateComplete(note.dateCreation)}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
            if (note.dateModification != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.edit_calendar, size: 14, color: Colors.grey[400]),
                  const SizedBox(width: 6),
                  Text(
                    'Modifiée le ${_formatDateComplete(note.dateModification!)}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ],
            const Divider(height: 32),
            Text(
              note.contenu.isEmpty ? '(Aucun contenu)' : note.contenu,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}