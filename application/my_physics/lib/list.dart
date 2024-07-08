// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'details.dart';
import 'talks.dart';

class VideoListPage extends StatefulWidget {
  final String currentId;

  const VideoListPage({super.key, required this.currentId});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<Talk> talks = [];

  @override
  void initState() {
    super.initState();
    fetchTalks(widget.currentId);
  }

  void fetchTalks(String currentId) async {
    int limit = 30; // Numero massimo di video da caricare

    for (int i = 0; i < limit; i++) {
      final response = await http.post(
        Uri.https('xsg3anuydc.execute-api.us-east-1.amazonaws.com', '/default/watchNext2'),
        body: jsonEncode({'current_id': currentId}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Talk talk = Talk.fromJson(data);

        setState(() {
          talks.add(talk);
          currentId = data['_id']; // Aggiorna currentId per il prossimo ciclo
        });
      } else {
        throw Exception('Failed to load video');
      }
    }
  }

  void reloadWatchNext() async {
    try {
      final response = await http.get(
        Uri.https('n75574y4xd.execute-api.us-east-1.amazonaws.com', '/default/reloadWatchNext'),
      );

      if (response.statusCode == 200) {
       
        print('Database updated successfully');
        print('API response: ${response.body}');
        if (response.body == 'Glue job started successfully') {
          print('Glue job started successfully');
        } else {
          print('Unexpected API response: ${response.body}');
        }
        setState(() {
          talks.clear(); // Svuota la lista di talks dopo il reload
          fetchTalks(widget.currentId); // Ricarica i dati dopo il reload
        });
      } else {
        throw Exception('Failed to reload data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], 

      body: ListView.builder(
        itemCount: talks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                talks[index].imageUrl ?? 'https://example.com/default_avatar.jpg', // Percorso immagine del relatore
              ),
            ),
            title: Text(
              talks[index].title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              talks[index].speakers,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Naviga alla pagina dei dettagli del video
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoDetailsPage(talk: talks[index]),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.cyan), 
              ),
              child: const Text(
                'Guarda',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            reloadWatchNext();
          }, // Icona di reload bianca
          backgroundColor: Colors.cyan, 
          elevation: 2.0,
          child: const Icon(Icons.refresh, color: Colors.white), 
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked, // Posizione del pulsante fluttuante
    );
  }
}
