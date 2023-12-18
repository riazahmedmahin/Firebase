import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FootballMatch {
  final String team1;
  final String team2;
  final int goalsTeam1;
  final int goalsTeam2;
  final String totalTime;
  final String time;

  FootballMatch({
    required this.team1,
    required this.team2,
    required this.goalsTeam1,
    required this.goalsTeam2,
    required this.totalTime,
    required this.time,
  });
}

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('matches').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Matches Available'),
            );
          }

          final matches = snapshot.data!.docs;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final matchData = match.data() as Map<String, dynamic>;

              final footballMatch = FootballMatch(
                team1: matchData['team1'],
                team2: matchData['team2'],
                goalsTeam1: matchData['goalsTeam1'],
                goalsTeam2: matchData['goalsTeam2'],
                totalTime: matchData['totalTime'],
                time: matchData['time'],
              );

              return ListTile(
                title: Text('${footballMatch.team1} vs ${footballMatch.team2}'),
                trailing: const Icon(Icons.arrow_forward_outlined),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchDetailsScreen(matchData: footballMatch),
                      // Pass FootballMatch object directly
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class MatchDetailsScreen extends StatelessWidget {
  final FootballMatch matchData;

  const MatchDetailsScreen({Key? key, required this.matchData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${matchData.team1} vs ${matchData.team2}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Reduce padding size here
        child: Card(

          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Reduce padding size here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${matchData.team1} vs ${matchData.team2}',
                    style: const TextStyle(
                        fontSize: 16, // Reduce font size here
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5), // Reduce spacer size here
                  Text(
                    '${matchData.goalsTeam1}:${matchData.goalsTeam2}',
                    style: const TextStyle(
                        fontSize: 20, // Reduce font size here
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5), // Reduce spacer size here
                  Text(
                    'Time: ${matchData.time}',
                    style: const TextStyle(
                        fontSize: 14, // Reduce font size here
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5), // Reduce spacer size here
                  Text(
                    'Total Time: ${matchData.totalTime}',
                    style: const TextStyle(
                        fontSize: 14, // Reduce font size here
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Other details you want to display
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




