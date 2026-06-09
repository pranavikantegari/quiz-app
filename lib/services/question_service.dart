import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuestionService {
  Future<List<Question>> loadQuestions() async{
    final String data = await rootBundle.loadString(
      'assets/questions.json',
    );

    final List<dynamic> jsonResult =
    json.decode(data);
    return jsonResult.map(
          (item) => Question.fromJson(item),
    )
        .toList();
  }
}