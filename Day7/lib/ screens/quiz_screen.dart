import 'package:flutter/material.dart';

import '../widgets/answer_button.dart';

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctAnswer;

  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      question: 'Which widget is used to manage mutable local state?',
      answers: [
        'StatelessWidget',
        'StatefulWidget',
        'Container',
        'MaterialApp',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      question: 'Which method is used to update the UI after state changes?',
      answers: ['build()', 'dispose()', 'setState()', 'initState()'],
      correctAnswer: 2,
    ),
    QuizQuestion(
      question: 'Which method is called when a State object is first created?',
      answers: ['initState()', 'dispose()', 'setState()', 'didUpdateWidget()'],
      correctAnswer: 0,
    ),
    QuizQuestion(
      question: 'Which method is used to clean up resources?',
      answers: ['build()', 'dispose()', 'createState()', 'setState()'],
      correctAnswer: 1,
    ),
  ];
  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _quizFinished = false;

  void _selectAnswer(int index) {
    if (_showResult) {
      return;
    }
    setState(() {
      _selectedAnswer = index;
      _showResult = true;

      if (index == _questions[_currentQuestion].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (!_showResult) {
      return;
    }
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _selectedAnswer = null;
      _showResult = false;
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz App')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'Quiz Completed!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your Score: $_score / ${_questions.length}',
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _restartQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Quiz'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final question = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Score: $_score',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Question ${_currentQuestion + 1} of ${_questions.length}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (_currentQuestion + 1) / _questions.length,
          ),
          const SizedBox(height: 28),
          Text(
            question.question,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ...List.generate(question.answers.length, (index) {
            return AnswerButton(
              text: question.answers[index],
              selected: _selectedAnswer == index,
              correct: index == question.correctAnswer,
              showResult: _showResult,
              onPressed: () {
                _selectAnswer(index);
              },
            );
          }),
          const SizedBox(height: 24),
          if (_showResult)
            FilledButton(
              onPressed: _nextQuestion,
              child: Text(
                _currentQuestion == _questions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question',
              ),
            ),
        ],
      ),
    );
  }
}
