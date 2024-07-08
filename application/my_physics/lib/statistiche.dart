import 'package:flutter/material.dart';

class StatistichePage extends StatelessWidget {
  final int videosWatchedPerDay = 5;
  final int videosWatchedPerMonth = 100;
  final String mostWatchedCategory = "Comedy";
  final int totalMinutesWatched = 1200;

  const StatistichePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/statistic.png',
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow, color: Colors.cyan),
                const SizedBox(width: 8.0),
                Text(
                  "Videos watched per day: $videosWatchedPerDay",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8.0),
                Text(
                  "Videos watched per month: $videosWatchedPerMonth",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.category, color: Colors.cyan), 
                const SizedBox(width: 8.0),
                Text(
                  "Most watched category: $mostWatchedCategory",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.cyan), 
                const SizedBox(width: 8.0),
                Text(
                  "Total minutes watched: $totalMinutesWatched",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
