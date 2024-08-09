import 'package:flutter/material.dart';

class CompletedPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const CompletedPage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1488433341267-2cf917b899f9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHRyZWVzfGVufDB8fDB8fHww'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.08,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'You have completed the Quiz',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.06,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.07,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$score/$totalQuestions',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.restorablePushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 221, 206, 224),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
