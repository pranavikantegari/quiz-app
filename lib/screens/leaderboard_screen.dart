import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('scores');
    final scores = box.values.toList();
    scores.sort(
          (a, b) => b.compareTo(a),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
        ),
      ),
      body: ListView.builder(
        itemCount: scores.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  "${index + 1}",
                ),
              ),
              title: Text(
                "Score: ${scores[index]}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.emoji_events,
                color: Colors.amber,
              ),
            ),
          );
        },
      ),
    );
  }
}