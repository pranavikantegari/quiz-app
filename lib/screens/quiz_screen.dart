import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/question_service.dart';
import 'result_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  List<Question> questions = [];
  bool isLoading = true;
  int timeLeft = 30;
  Timer? timer;
  final AudioPlayer player = AudioPlayer();

  Future<void> loadQuestions() async {
    try {
      print("STEP 1");
      final loadedQuestions =
      await QuestionService().loadQuestions();

      print("STEP 2");
      loadedQuestions.shuffle();
      questions = loadedQuestions.take(10).toList();

      print("Questions loaded: ${questions.length}");
      setState(() {
        isLoading = false;
      });

      print("STEP 3");

      startTimer();
    } catch (e) {
      print("ERROR: $e");
    }
  }
  void startTimer() {
    timer?.cancel();
    timeLeft = 30;

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        }
        else {
          timer.cancel();

          if (currentQuestion < questions.length - 1) {
            setState(() {
              currentQuestion++;
              selectedAnswer = null;
            });
            startTimer();
          }
          else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  score: score,
                  total: questions.length,
                ),
              ),
            );
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void checkAnswer(int selectedIndex) {
    setState(() {
      selectedAnswer = selectedIndex;
    });

    Future.delayed(
      const Duration(seconds: 1),
          () {
            bool isCorrect =
                questions[currentQuestion].answers[selectedIndex] ==
                    questions[currentQuestion].correctAnswer;

            if (isCorrect) {
              score++;
              player.play(
                AssetSource(
                  'sounds/correct.mp3',
                ),
              );
            }
            else {
              player.play(
                AssetSource(
                  'sounds/wrong.mp3',
                ),
              );

            }

        timer?.cancel();

        if (currentQuestion < questions.length - 1) {
          setState(() {
            currentQuestion++;
            selectedAnswer = null;
          });
          startTimer();
        }
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResultScreen(
                    score: score,
                    total: questions.length,
                  ),
            ),
          );

        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Java Quiz Master",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Question ${currentQuestion + 1} / ${questions.length}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 15),
            LinearProgressIndicator(
              value:
              (currentQuestion + 1) / questions.length,
            ),

            const SizedBox(height: 25),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),
            ...List.generate(
              question.answers.length,
                  (index) {
                bool isCorrect =
                    question.answers[index] == question.correctAnswer;
                bool isSelected = selectedAnswer == index;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: RadioListTile<int>(
                    title: Text(
                      question.answers[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    value: index,
                    groupValue: selectedAnswer,
                    onChanged: (value) {
                      if (selectedAnswer == null) {
                        checkAnswer(value!);
                      }
                    },

                    tileColor: isSelected
                        ? (isCorrect
                        ? Colors.green.shade200
                        : Colors.red.shade200)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: timeLeft / 30,
              minHeight: 10,
            ),

            const SizedBox(height: 10),
            Text(
              "Time Left: $timeLeft sec",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}