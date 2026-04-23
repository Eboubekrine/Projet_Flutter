import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? note;

  const CreateNotePage({super.key, this.note});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late TextEditingController _titreController;
  late TextEditingController _contenuController;

  String _couleurSelectionnee = '#FFE082';

  final List<String> _couleurs = [
    '#FFE082',
    '#EF9A9A',
    '#A5D6A7',
    '#90CAF9',
    '#CE93D8',
    '#FFCC80',
  ];

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(
      text: widget.note?.titre ?? '',
    );
    _contenuController = TextEditingController(
      text: widget.note?.contenu ?? '',
    );
    if (widget.note != null) {
      _couleurSelectionnee = widget.note!.couleur;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  void _sauvegarder() {
    final titre = _titreController.text.trim();

    if (titre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre ne peut pas être vide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Note note;

    if (widget.note == null) {
      note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titre: titre,
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateCreation: DateTime.now(),
      );
    } else {
      note = widget.note!.copyWith(
        titre: titre,
        contenu: _contenuController.text.trim(),
        couleur: _couleurSelectionnee,
        dateModification: DateTime.now(),
      );
    }

    Navigator.pop(context, note);
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final estModification = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(estModification ? 'Modifier la note' : 'Nouvelle Note'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _sauvegarder,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titreController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Titre de la note',
                hintText: 'Ex : Liste de courses',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contenuController,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Contenu',
                hintText: 'Écrivez votre note ici…',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Couleur :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _couleurs.map((hex) {
                final couleur = _hexToColor(hex);
                final estSelectionne = hex == _couleurSelectionnee;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _couleurSelectionnee = hex;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: estSelectionne ? 44 : 36,
                    height: estSelectionne ? 44 : 36,
                    decoration: BoxDecoration(
                      color: couleur,
                      shape: BoxShape.circle,
                      border: estSelectionne
                          ? Border.all(color: Colors.black87, width: 3)
                          : Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sauvegarder,
                icon: const Icon(Icons.save),
                label: Text(
                  estModification ? 'Modifier la note' : 'Créer la note',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}