import 'package:flutter/material.dart';
import 'package:provider/provider.dart';          // ← import Provider
import 'services/note_service.dart';
import 'pages/home_page_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Crée le NoteService une seule fois au démarrage
      create: (_) => NoteService(),
      // Tout ce qui est en dessous peut accéder au NoteService
      child: MaterialApp(
        title: 'Bloc-Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: const HomePageV2(),
      ),
    );
  }
}