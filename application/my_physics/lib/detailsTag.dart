// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'talksTag.dart'; // Importa la classe TalkTag
import 'package:url_launcher/url_launcher.dart'; // Importa il pacchetto per il reindirizzamento URL

class VideoDetailsPageTag extends StatelessWidget {
  final TalkTag talk;

  const VideoDetailsPageTag({super.key, required this.talk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(talk.title),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostra l'immagine dell'articolo
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(talk.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              talk.description,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
           const  SizedBox(height: 16),
           const Text(
              'Speaker:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              talk.speakers,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'URL:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              child: Text(
                talk.url,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              onTap: () {
                launch(talk.url); // Apre l'URL in un browser esterno
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  launch(talk.url); // Apre l'URL in un browser esterno
                },
                child: const Text('See more details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
