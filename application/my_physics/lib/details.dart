import 'package:flutter/material.dart';
import 'talks.dart'; 

class VideoDetailsPage extends StatelessWidget {
  final Talk talk;

  const VideoDetailsPage({super.key, required this.talk});

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
            const SizedBox(height: 16),
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
                // Implementa il reindirizzamento all'URL qui
                // Esempio di apertura dell'URL in un browser esterno
                // Puoi utilizzare il pacchetto url_launcher per implementare il reindirizzamento
                // import 'package:url_launcher/url_launcher.dart';
                // launch(talk.url);
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implementa il reindirizzamento all'URL qui
                  // Esempio di apertura dell'URL in un browser esterno
                  // Puoi utilizzare il pacchetto url_launcher per implementare il reindirizzamento
                  // import 'package:url_launcher/url_launcher.dart';
                  // launch(talk.url);
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
