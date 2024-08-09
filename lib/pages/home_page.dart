// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sitp_quiz_app/features/options.dart';
import 'package:sitp_quiz_app/pages/completed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List responsiveData = [];
  int number = 0;
  Timer? _timer;
  int secondsRemaining = 15;

  List<String> shuffledOptions = [];

  String? selectedOptions;

  int score = 0;

  Future<void> api() async {
    final response =
        await http.get(Uri.parse('https://opentdb.com/api.php?amount=10'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];

      setState(() {
        responsiveData = data;
        if (responsiveData.isNotEmpty) {
          updateShuffleOptions();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    api();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void nextQuestion() {
    if (selectedOptions == responsiveData[number]['correct_answer']) {
      score++;
    }
    if (number < responsiveData.length - 1) {
      setState(() {
        number++;
        updateShuffleOptions();
        selectedOptions = null;
        secondsRemaining = 15;
      });
    } else {
      completed();
    }
  }

  void completed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedPage(
          score: score,
          totalQuestions: responsiveData.length,
        ),
      ),
    );
  }

  void updateShuffleOptions() {
    var currentQuestion = responsiveData[number];
    List<String> options =
        List<String>.from(currentQuestion['incorrect_answers']);
    options.add(currentQuestion['correct_answers']);
    options.shuffle();

    setState(() {
      shuffledOptions = options;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          nextQuestion();
          secondsRemaining = 15;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: screensize.height * 0.5,
              width: screensize.width * 0.9,
              child: Stack(
                children: [
                  Container(
                    height: screensize.height * 0.4,
                    width: screensize.width * 0.85,
                    decoration: BoxDecoration(
                      color: const Color(0XFFA42FC1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 2,
                          color: Color(0xffa42fc1).withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 22,
                    child: Container(
                      height: screensize.height * 0.3,
                      width: screensize.width * 0.85,
                      decoration: BoxDecoration(
                        color: const Color(0XFFA42FC1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            spreadRadius: 3,
                            color: Color(0xffa42fc1).withOpacity(0.4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Question ${number + 1}/10',
                                style: TextStyle(
                                  color: Color(0xffa42fc1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              responsiveData.isNotEmpty
                                  ? responsiveData[number]['question']
                                  : 'loading.....',
                              style: TextStyle(
                                fontSize: screensize.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.quiz_rounded,
                      color: Colors.red,
                      size: screensize.width * 0.1,
                    ),
                  ),
                  Positioned(
                    bottom: screensize.height * 0.35,
                    left: screensize.width * 0.4,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.amber,
                      child: Center(
                        child: Text(
                          secondsRemaining.toString(),
                          style: TextStyle(
                            color: Color(0xffa42fc1),
                            fontSize: screensize.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: responsiveData.isNotEmpty &&
                        responsiveData[number]['incorrect_answer'] != null
                    ? shuffledOptions.length
                    : 0,
                itemBuilder: (context, index) {
                  String option = shuffledOptions[index];
                  return Options(
                    option: option,
                    onSelected: (String value) {
                      setState(() {
                        selectedOptions = value;
                      });
                    },
                    isSelected: selectedOptions == option,
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffa42ffc1),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: nextQuestion,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
