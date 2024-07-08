// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_physics/detailsTag.dart';
import 'package:my_physics/talksTag.dart'; 

class RicercaPage extends StatefulWidget {
  const RicercaPage({super.key});

  @override
  _RicercaPageState createState() => _RicercaPageState();
}

class _RicercaPageState extends State<RicercaPage> {
  final TextEditingController _tagController = TextEditingController();
  List<TalkTag> _talks = [];
  bool _loading = false; // Flag per indicare se stiamo caricando i dati
  bool _showNoResultsMessage = false; // Flag per mostrare il messaggio "Non ci sono talks con questo tag"
  bool _showInitialMessage = true; // Flag per mostrare il messaggio iniziale di benvenuto

  Future<void> _searchByTag(String tag) async {
    setState(() {
      _loading = true; // Attiviamo il flag di caricamento
      _showNoResultsMessage = false; // Nascondiamo il messaggio di nessun risultato
      _showInitialMessage = false; // Nascondiamo il messaggio iniziale
    });

    try {
      final response = await http.post(
        Uri.https(
          '8sz6op4yy6.execute-api.us-east-1.amazonaws.com',
          '/default/watchByTag',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'tag': tag}),
      );

      print('Response body: ${response.body}'); // Debug: Stampa il corpo della risposta

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<TalkTag> talks = data.map((e) => TalkTag.fromJson(e)).toList();
        setState(() {
          _talks = talks;
          _loading = false; // Disattiviamo il flag di caricamento dopo aver caricato i dati
          if (_talks.isEmpty) {
            _showNoResultsMessage = true; // Mostraimo il messaggio di nessun risultato solo se non ci sono talks
          }
        });
      } else {
        throw Exception('Failed to load talks');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false; // Disattiviamo il flag di caricamento in caso di errore
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cerca per tag',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
           const  SizedBox(height: 16),
            if (_showInitialMessage) // Mostra il messaggio iniziale solo se _showInitialMessage == true
              const Text(
                'Inserisci un tag e premi "Cerca" per visualizzare i risultati.',
                style: TextStyle(color: Colors.white),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Inserisci il tag',
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String tag = _tagController.text.trim();
                if (tag.isNotEmpty) {
                  _searchByTag(tag);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cerca',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(), // Visualizza un indicatore di caricamento durante il caricamento dei dati
                  )
                : _showNoResultsMessage
                    ? const Center(
                        child: Text(
                          'Non ci sono talks con questo tag.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : _talks.isEmpty
                        ? Container() // Mostra un contenitore vuoto se non ci sono talks per evitare che il ListViewBuilder fallisca
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _talks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: _talks[index].imageUrl != null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(_talks[index].imageUrl),
                                        )
                                      : const CircleAvatar(), // Immagine se imageUrl non è null, altrimenti CircleAvatar vuoto
                                  title: Text(
                                    _talks[index].title ?? 'Titolo non disponibile', // Gestisce il titolo nullo
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    _talks[index].speakers ?? 'Relatore non disponibile', // Gestisce il nome del relatore nullo
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoDetailsPageTag(talk: _talks[index]),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyan,
                                    ),
                                    child: const Text(
                                      'Guarda',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
